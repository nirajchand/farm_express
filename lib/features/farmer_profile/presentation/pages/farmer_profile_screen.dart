import 'dart:io';

import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/farmer_profile/domain/usecases/update_farmer_profile_usecases.dart';
import 'package:farm_express/features/farmer_profile/presentation/state/farmer_profile_state.dart';
import 'package:farm_express/features/farmer_profile/presentation/view_model/farmer_profile_viewmodel.dart';
import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:farm_express/theme/theme_provider.dart';
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
    required Color textColor,
    required dynamic colors,
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
          Icon(Icons.edit, color: colors.primary, size: 20),
        ],
      ),
    );
  }

  // ─── Field label ─────────────────────────────────────────────────────────

  Widget _fieldLabel(String label, {required dynamic colors}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: colors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ─── Info card ────────────────────────────────────────────────────────────

  Widget _infoCard({required List<Widget> children, required dynamic colors}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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

  Widget _sectionTitle(String title, {required dynamic colors}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
  // ─── Theme Menu ───────────────────────────────────────────────────────────

  void _showThemeMenu(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    dynamic colors,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Theme Settings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Auto Theme Toggle with Circular Checkbox
              Consumer(
                builder: (context, ref, child) {
                  final autoThemeEnabled = ref.watch(autoThemeProvider);
                  return GestureDetector(
                    onTap: () {
                      if (autoThemeEnabled) {
                        ref.read(autoThemeProvider.notifier).disableAutoTheme();
                      } else {
                        ref.read(autoThemeProvider.notifier).enableAutoTheme();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: autoThemeEnabled
                            ? colors.primary?.withAlpha(25) ??
                                  Colors.blue.withAlpha(25)
                            : colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: autoThemeEnabled
                              ? colors.primary ?? Colors.blue
                              : colors.textSecondary?.withAlpha(50) ??
                                    Colors.grey.withAlpha(50),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Circular Checkbox
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.primary ?? Colors.blue,
                                width: 2,
                              ),
                              color: autoThemeEnabled
                                  ? colors.primary ?? Colors.blue
                                  : Colors.transparent,
                            ),
                            child: autoThemeEnabled
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Auto Theme",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  "Follow environment light automatically",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Manual Theme Selection
              Text(
                "Manual Theme Selection",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Light Mode Option
              GestureDetector(
                onTap: () {
                  // Disable auto theme and set to light
                  ref.read(autoThemeProvider.notifier).disableAutoTheme();
                  ref.read(themeModeProvider.notifier).setLightTheme();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        colors.primary?.withAlpha(15) ??
                        Colors.blue.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.light_mode,
                        color: colors.primary ?? Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Light Mode",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Dark Mode Option
              GestureDetector(
                onTap: () {
                  // Disable auto theme and set to dark
                  ref.read(autoThemeProvider.notifier).disableAutoTheme();
                  ref.read(themeModeProvider.notifier).setDarkTheme();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        colors.primary?.withAlpha(15) ??
                        Colors.blue.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: colors.primary ?? Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColorsDark() : AppColorsLight() as dynamic;
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
            // ─── Top Header with Profile Image and Menu ───────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Image on Left
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: _selectedMedia.isNotEmpty
                              ? FileImage(File(_selectedMedia.first.path))
                              : (profile?.profileImage != null &&
                                    profile!.profileImage!.isNotEmpty)
                              ? NetworkImage(
                                  "${ApiEndpoints.serverUrl}${profile.profileImage}",
                                )
                              : const AssetImage("assets/images/healthy.jpg")
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? "Farmer Name",
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile?.email ?? "email@example.com",
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  // Hamburger Menu on Right
                  GestureDetector(
                    onTap: () => _showThemeMenu(context, ref, isDark, colors),
                    child: Icon(
                      Icons.menu,
                      color: colors.textPrimary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // ─── Profile Card ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withAlpha(128),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logout button
                        GestureDetector(
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            await ref
                                .read(authViewModelProvider.notifier)
                                .logout();
                            if (mounted) {
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChooseRoleScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: const Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),

            // ── Personal Information ─────────────────────────────────────
            _sectionTitle("Personal Information", colors: colors),
            _infoCard(
              colors: colors,
              children: [
                _fieldLabel("Full Name", colors: colors),
                _editableRow(
                  value: profile?.fullName ?? "Enter Name",
                  textColor: colors.textPrimary,
                  colors: colors,
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
                _fieldLabel("Email", colors: colors),
                _editableRow(
                  value: profile?.email ?? "Enter email",
                  textColor: colors.textPrimary,
                  colors: colors,
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
                _fieldLabel("Phone", colors: colors),
                _editableRow(
                  value: "+977 ${profile?.phoneNumber ?? "Enter number"}",
                  textColor: colors.textPrimary,
                  colors: colors,
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
            _sectionTitle("Farm Information", colors: colors),
            _infoCard(
              colors: colors,
              children: [
                _fieldLabel("Farm Name", colors: colors),
                _editableRow(
                  value: profile?.farmName ?? "Enter farm name",
                  textColor: colors.textPrimary,
                  colors: colors,
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
                _fieldLabel("Description", colors: colors),
                _editableRow(
                  value: profile?.description ?? "Enter farm description",
                  textColor: colors.textPrimary,
                  colors: colors,
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
                _fieldLabel("Location", colors: colors),
                _editableRow(
                  value: profile?.farmLocation ?? "Enter location",
                  textColor: colors.textPrimary,
                  colors: colors,
                  onEdit: () => _showEditDialog(
                    title: "Location",
                    initialValue: profile?.farmLocation ?? "",
                    keyboardType: TextInputType.text,
                    onSave: (value) {
                      if (value.isEmpty) return;
                      ref
                          .read(farmerProfileViewmodelProvider.notifier)
                          .updateProfile(
                            UpdateFarmerProfileUsecaseParams(
                              farmLocation: value,
                            ),
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
