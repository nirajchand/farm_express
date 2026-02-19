import 'dart:io';

import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/services/storage/user_session_service.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/farmer_dashboard/presentation/pages/navigation_farmer.dart';
import 'package:farm_express/features/product/domain/usecases/add_product_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/state/product_state.dart';
import 'package:farm_express/features/product/presentation/farmer/view_model/add_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum UnitType { kg, piece, litre, dozen }

enum ProductStatus { Growing, Ready, Sold }

extension UnitTypeExt on UnitType {
  String get label {
    switch (this) {
      case UnitType.kg:
        return 'Kilogram (kg)';
      case UnitType.piece:
        return 'Piece';
      case UnitType.litre:
        return 'Litre';
      case UnitType.dozen:
        return 'Dozen';
    }
  }
}

extension ProductStatusExt on ProductStatus {
  String get label {
    switch (this) {
      case ProductStatus.Growing:
        return 'Growing';
      case ProductStatus.Ready:
        return 'Ready';
      case ProductStatus.Sold:
        return 'Sold';
    }
  }
}

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  UnitType? _unit;
  ProductStatus? _status;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _quantityCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  // ---------------- PERMISSION ----------------

  Future<bool> _getPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

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
        content: const Text(
          "Permission permanently denied. Enable it from settings.",
        ),
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

  // ---------------- IMAGE ----------------

  Future<void> _openCamera() async {
    final granted = await _getPermission(Permission.camera);
    if (!granted) return;

    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file != null) {
      setState(() => _image = File(file.path));
    }
  }


  Future<void> _openGallery() async {

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (file != null) {
        setState(() => _image = File(file.path));
      }
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

  // ---------------- SUBMIT ----------------

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_unit == null || _status == null) {
      SnackbarUtils.showError(context, "Select unit and status");
      return;
    }

    final farmerId = ref.read(userSessionServiceProvider).getCurrentUserId();

    if (farmerId == null || farmerId.isEmpty) {
      SnackbarUtils.showError(context, "User session expired. Login again.");
      return;
    }

    await ref
        .read(addProductViewModelProvider.notifier)
        .addProduct(
          AddProductUseCaseParams(
            farmerId: farmerId,
            productName: _nameCtrl.text.trim(),
            price: double.tryParse(_priceCtrl.text) ?? 0,
            quantity: double.tryParse(_quantityCtrl.text) ?? 0,
            unitType: _unit!.name,
            status: _status!.name,
            description: _descriptionCtrl.text.trim(),
            image: _image,
          ),
        );

    if (!mounted) return;

    final state = ref.read(addProductViewModelProvider);

    if (state.status == ProductStateStatus.success) {
      SnackbarUtils.showSuccess(context, "Product saved successfully");

      _formKey.currentState!.reset();

      setState(() {
        _image = null;
        _unit = null;
        _status = null;
      });
    }

    if (state.status == ProductStateStatus.failure) {
      SnackbarUtils.showError(
        context,
        state.errorMessage ?? "Error saving product",
      );
    }
  }

  // ---------------- VALIDATORS ----------------

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? "Required" : null;

  String? _number(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (double.tryParse(v) == null) return "Invalid number";
    return null;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductViewModelProvider);

    ref.listen(addProductViewModelProvider, (previous, next) {
      if (next.status == ProductStateStatus.success) {
        SnackbarUtils.showSuccess(context, "Product saved successfully");

        _formKey.currentState?.reset();

        setState(() {
          _image = null;
          _unit = null;
          _status = null;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FarmerBottonNavigationScreen(),
          ),
        );
      }

      if (next.status == ProductStateStatus.failure) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Error saving product",
        );
      }
    });

    return Scaffold(
      backgroundColor: kWhiteback,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Add Product"),
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
                          decimal: true,
                        ),
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

            _submitButton(state.status == ProductStateStatus.loading),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w600));
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
    int maxLines = 1,
    Widget? prefix,
  }) {
    return TextFormField(
      controller: controller,
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
    if (_image != null) {
      return GestureDetector(
        onTap: _pickImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(_image!, height: 150, fit: BoxFit.cover),
        ),
      );
    }

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

  Widget _submitButton(bool loading) {
    return ElevatedButton(
      onPressed: loading ? null : _submitProduct,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("Save Product"),
    );
  }
}
