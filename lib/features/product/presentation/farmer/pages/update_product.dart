// update_product_screen.dart

import 'dart:io';

import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/usecases/update_product_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/pages/add_products.dart'; // for UnitType & ProductStatus enums
import 'package:farm_express/features/product/presentation/farmer/state/farmer_product.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/farmer_product_view_model.dart';
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
  File? _newImage; // null = keep existing image

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p.productName ?? "");
    _priceCtrl = TextEditingController(text: p.price?.toString() ?? "");
    _quantityCtrl = TextEditingController(text: p.quantity?.toString() ?? "");
    _descriptionCtrl = TextEditingController(text: p.description ?? "");

    // Pre-select unit & status from product
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
    if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    }
    return false;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Enable it from app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: openAppSettings,
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    final granted = await _getPermission(Permission.camera);
    if (!granted) return;
    final XFile? file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file != null) setState(() => _newImage = File(file.path));
  }

  Future<void> _openGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);
      if (file != null) setState(() => _newImage = File(file.path));
    } catch (_) {
      if (!mounted) return;
      SnackbarUtils.showError(context, "Gallery access failed");
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: kWhiteback,
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
                leading: const Icon(Icons.camera_alt),
                title: const Text("Open Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Open Gallery"),
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
            image: _newImage, // null = keep existing image on backend
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

    return Scaffold(
      backgroundColor: kWhiteback,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Update Product"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _label("Product Name"),
            _input(_nameCtrl, "Name", validator: _required),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Price"),
                      _input(
                        _priceCtrl,
                        "0.00",
                        keyboard: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: _number,
                        prefix: const Text("Rs. "),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Quantity"),
                      _input(
                        _quantityCtrl,
                        "0",
                        keyboard: TextInputType.number,
                        validator: _number,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _label("Unit Type"),
            Wrap(
              spacing: 8,
              children: UnitType.values.map((u) {
                return ChoiceChip(
                  label: Text(u.label),
                  selected: _unit == u,
                  onSelected: (_) => setState(() => _unit = u),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _label("Status"),
            Row(
              children: ProductStatus.values.map((s) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s.label),
                      selected: _status == s,
                      onSelected: (_) => setState(() => _status = s),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _label("Description"),
            _input(_descriptionCtrl, "Write details...", maxLines: 4),

            const SizedBox(height: 20),

            _label("Product Image"),
            _imageWidget(),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
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

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600));

  Widget _input(
    TextEditingController ctrl,
    String hint, {
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
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _imageWidget() {
    // If user picked a new image, show it
    if (_newImage != null) {
      return GestureDetector(
        onTap: _pickImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(_newImage!, height: 150, fit: BoxFit.cover),
        ),
      );
    }

    // Otherwise show existing network image
    final existingUrl = widget.product.productImage;
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ApiEndpoints.serverUrl+existingUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

    // No image at all
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text("Choose Image")),
      ),
    );
  }
}