// update_product_screen.dart

import 'dart:io';

import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/usecases/update_product_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart';
import 'package:farm_express/features/product/presentation/farmer/state/farmer_product.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateProductScreen extends ConsumerStatefulWidget {
  final ProductEntities product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  ConsumerState<UpdateProductScreen> createState() =>
      _UpdateProductScreenState();
}

class _UpdateProductScreenState extends ConsumerState<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _quantityCtrl;
  late final TextEditingController _descriptionCtrl;

  UnitType? _unit;
  ProductStatus? _status;
  File? _newImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p.productName ?? "");
    _priceCtrl = TextEditingController(text: p.price?.toString() ?? "");
    _quantityCtrl = TextEditingController(text: p.quantity?.toString() ?? "");
    _descriptionCtrl = TextEditingController(text: p.description ?? "");
    _unit = UnitType.values.firstWhere(
      (u) => u.name == p.unitType,
      orElse: () => UnitType.kg,
    );
    _status = ProductStatus.values.firstWhere(
      (s) => s.name == p.status,
      orElse: () => ProductStatus.Growing,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _quantityCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  // ---------- Image Picking ----------

  Future<bool> _getPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) return (await permission.request()).isGranted;
    if (status.isPermanentlyDenied) _showPermissionDialog();
    return false;
  }

  void _showPermissionDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          "Permission Required",
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          "Enable it from app settings.",
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: openAppSettings,
            child: Text(
              "Open Settings",
              style: TextStyle(color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    final granted = await _getPermission(Permission.camera);
    if (!granted) return;
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null) setState(() => _newImage = File(file.path));
  }

  Future<void> _openGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) setState(() => _newImage = File(file.path));
    } catch (_) {
      if (!mounted) return;
      SnackbarUtils.showError(context, "Gallery access failed");
    }
  }

  Future<void> _pickImage() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: colors.primary),
                title: Text(
                  "Open Camera",
                  style: TextStyle(color: colors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo, color: colors.primary),
                title: Text(
                  "Open Gallery",
                  style: TextStyle(color: colors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Submit ----------

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_unit == null || _status == null) {
      SnackbarUtils.showError(context, "Select unit and status");
      return;
    }
    final success = await ref
        .read(farmerProductViewModelProvider.notifier)
        .updateProduct(
          UpdateProductUseCaseParams(
            productId: widget.product.id!,
            productName: _nameCtrl.text.trim(),
            price: double.tryParse(_priceCtrl.text) ?? 0,
            quantity: double.tryParse(_quantityCtrl.text) ?? 0,
            unitType: _unit!.name,
            status: _status!.name,
            description: _descriptionCtrl.text.trim(),
            image: _newImage,
          ),
        );
    if (!mounted) return;
    if (success) {
      SnackbarUtils.showSuccess(context, "Product updated successfully");
      Navigator.pop(context);
    } else {
      final errMsg = ref.read(farmerProductViewModelProvider).errorMessage;
      SnackbarUtils.showError(context, errMsg ?? "Update failed");
    }
  }

  // ---------- Validators ----------

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? "Required" : null;

  String? _number(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (double.tryParse(v) == null) return "Invalid number";
    return null;
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(farmerProductViewModelProvider);
    final isLoading = state.status == FarmerProductStatus.loading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: Text(
          "Update Product",
          style: TextStyle(color: colors.textPrimary),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _label("Product Name", colors),
            _input(_nameCtrl, "Name", colors, validator: _required),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Price", colors),
                      _input(
                        _priceCtrl,
                        "0.00",
                        colors,
                        keyboard: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _number,
                        prefix: Text(
                          "Rs. ",
                          style: TextStyle(color: colors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Quantity", colors),
                      _input(
                        _quantityCtrl,
                        "0",
                        colors,
                        keyboard: TextInputType.number,
                        validator: _number,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _label("Unit Type", colors),
            Wrap(
              spacing: 8,
              children: UnitType.values.map((u) {
                final isSelected = _unit == u;
                return ChoiceChip(
                  label: Text(
                    u.label,
                    style: TextStyle(
                      color: isSelected ? colors.white : colors.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: colors.primary,
                  backgroundColor: colors.surfaceVariant,
                  onSelected: (_) => setState(() => _unit = u),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _label("Status", colors),
            Row(
              children: ProductStatus.values.map((s) {
                final isSelected = _status == s;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        s.label,
                        style: TextStyle(
                          color: isSelected ? colors.white : colors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colors.primary,
                      backgroundColor: colors.surfaceVariant,
                      onSelected: (_) => setState(() => _status = s),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _label("Description", colors),
            _input(_descriptionCtrl, "Write details...", colors, maxLines: 4),

            const SizedBox(height: 20),

            _label("Product Image", colors),
            _imageWidget(colors),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.white,
                      ),
                    )
                  : const Text(
                      "Update Product",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController ctrl,
    String hint,
    dynamic colors, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
    int maxLines = 1,
    Widget? prefix,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: TextStyle(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.textHint),
        prefix: prefix,
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _imageWidget(dynamic colors) {
    if (_newImage != null) {
      return GestureDetector(
        onTap: _pickImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(_newImage!, height: 150, fit: BoxFit.cover),
        ),
      );
    }
    final existingUrl = widget.product.productImage;
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ApiEndpoints.serverUrl + existingUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.broken_image,
                  size: 60,
                  color: colors.textSecondary,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Change",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          border: Border.all(color: colors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: colors.primary,
                size: 32,
              ),
              const SizedBox(height: 6),
              Text("Choose Image", style: TextStyle(color: colors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
