import 'dart:io';

import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/farmer/farmer_profile/domain/usecases/update_farmer_profile_usecases.dart';
import 'package:farm_express/features/farmer/farmer_profile/presentation/state/farmer_profile_state.dart';
import 'package:farm_express/features/farmer/farmer_profile/presentation/view_model/farmer_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FarmerProfileScreen extends ConsumerStatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends ConsumerState<FarmerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(farmerProfileViewmodelProvider.notifier).getFarmerUser();
    });
  }

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  // ─── Permission helper ────────────────────────────────────────────────────

  Future<bool> _getPermissionFromUser(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Allow Permission"),
        content: const Text("Give permission to use"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // ─── Camera ───────────────────────────────────────────────────────────────

  Future<void> _useCameraForPhoto() async {
    final hasPermission = await _getPermissionFromUser(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo == null) return;
    setState(() {
      _selectedMedia
        ..clear()
        ..add(photo);
    });

    await ref
        .read(farmerProfileViewmodelProvider.notifier)
        .updateProfile(
          UpdateFarmerProfileUsecaseParams(profileImage: File(photo.path)),
        );
  }

  // ─── Gallery ──────────────────────────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedMedia
            ..clear()
            ..add(image);
        });
        await ref
            .read(farmerProfileViewmodelProvider.notifier)
            .updateProfile(
              UpdateFarmerProfileUsecaseParams(profileImage: File(image.path)),
            );
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  // ─── Bottom sheet picker ───────────────────────────────────────────

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: kWhiteback,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _useCameraForPhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.browse_gallery),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Edit dialog ──────────────────────────────────────────────────────────

  Future<void> _showEditDialog({
    required String title,
    required String initialValue,
    required TextInputType keyboardType,
    required Function(String) onSave,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: "Enter $title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ─── Editable row ─────────────────────────────────────────────────────────

  Widget _editableRow({
    required String value,
    required VoidCallback onEdit,
  }) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          Icon(Icons.edit, color: kPrimaryColor, size: 20),
        ],
      ),
    );
  }

  // ─── Field label ─────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: kPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ─── Info card ────────────────────────────────────────────────────────────

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(128),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // ─── Section title ────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(farmerProfileViewmodelProvider);

    if (profileState.status == FarmerProfileStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileState.status == FarmerProfileStatus.error) {
      return Center(child: Text(profileState.errorMessage ?? "Error"));
    }

    final profile = profileState.profile;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // ── Avatar card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(128),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _selectedMedia.isNotEmpty
                              ? FileImage(File(_selectedMedia.first.path))
                              : (profile?.profileImage != null &&
                                        profile!.profileImage!.isNotEmpty)
                                  ? NetworkImage(
                                      "http://10.0.2.2:2000${profile.profileImage}",
                                    )
                                  : const AssetImage(
                                      "assets/images/healthy.jpg",
                                    ) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile?.fullName ?? "Farmer Name",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          await ref
                              .read(authViewModelProvider.notifier)
                              .logout();
                          if (mounted) {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: const Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // ── Personal Information ─────────────────────────────────────
            _sectionTitle("Personal Information"),
            _infoCard(
              children: [
                _fieldLabel("Full Name"),
                _editableRow(
                  value: profile?.fullName ?? "Enter Name",
                  onEdit: () => _showEditDialog(
                    title: "Full Name",
                    initialValue: profile?.fullName ?? "",
                    keyboardType: TextInputType.text,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(fullName: value),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                _fieldLabel("Email"),
                _editableRow(
                  value: profile?.email ?? "Enter email",
                  onEdit: () => _showEditDialog(
                    title: "Email",
                    initialValue: profile?.email ?? "",
                    keyboardType: TextInputType.emailAddress,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(email: value),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                _fieldLabel("Phone"),
                _editableRow(
                  value: "+977 ${profile?.phoneNumber ?? "Enter number"}",
                  onEdit: () => _showEditDialog(
                    title: "Phone Number",
                    initialValue: profile?.phoneNumber ?? "",
                    keyboardType: TextInputType.phone,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(
                              phoneNumber: value,
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),

            // ── Farm Information ─────────────────────────────────────────
            _sectionTitle("Farm Information"),
            _infoCard(
              children: [
                _fieldLabel("Farm Name"),
                _editableRow(
                  value: profile?.farmName ?? "Enter farm name",
                  onEdit: () => _showEditDialog(
                    title: "Farm Name",
                    initialValue: profile?.farmName ?? "",
                    keyboardType: TextInputType.text,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(farmName: value),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                _fieldLabel("Description"),
                _editableRow(
                  value: profile?.description ?? "Enter farm description",
                  onEdit: () => _showEditDialog(
                    title: "Description",
                    initialValue: profile?.description ?? "",
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(
                              description: value,
                            ),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                _fieldLabel("Location"),
                _editableRow(
                  value: profile?.farmLocation ?? "Enter location",
                  onEdit: () => _showEditDialog(
                    title: "Location",
                    initialValue: profile?.farmLocation ?? "",
                    keyboardType: TextInputType.text,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(farmLocation: value),
                          );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
