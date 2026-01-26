import 'dart:io';

import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/consumer_profile/domain/usecases/update_consumer_profile_Usecase.dart';
import 'package:farm_express/features/consumer_profile/presentation/state/consumer_profile_state.dart';
import 'package:farm_express/features/consumer_profile/presentation/view_model/consumer_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(consumerProfileViewmodelProvider.notifier).getConsumerUser();
    });
  }

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<bool> _getPermissionFromUser(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }
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
        title: Text("Allow Permission"),
        content: Text("Give permission to use"),
        actions: [
          TextButton(onPressed: () {}, child: Text("Cancel")),
          TextButton(onPressed: () {}, child: Text("Open settings")),
        ],
      ),
    );
  }

  // code for camera
  Future<void> _useCameraForPhoto() async {
    final checkPermission = await _getPermissionFromUser(Permission.camera);
    if (!checkPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo == null) return;
    _selectedMedia.clear();
    _selectedMedia.add(photo);
    await ref
        .read(consumerProfileViewmodelProvider.notifier)
        .updateProfile(
          UpdateConsumerProfileUsecaseParams(profileImage: File(photo.path)),
        );
  }

  // code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
          });
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.add(image);
          });
        }
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

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: kWhiteback,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _useCameraForPhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Open Gallery'),
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

  Future<void> _showEditDialog({
    required String title,
    required String initialValue,
    required TextInputType keyboardType,
    required Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: "Enter $title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _editableRow({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 18, color: textColor)),
          Icon(Icons.edit, color: kPrimaryColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(consumerProfileViewmodelProvider);

    if (profileState.status == ConsumerProfileStatus.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (profileState.status == ConsumerProfileStatus.error) {
      return Center(child: Text(profileState.errorMessage ?? "Error"));
    }

    final profile = profileState.profile;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickMedia();
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: _selectedMedia.isNotEmpty
                              ? FileImage(File(_selectedMedia.first.path))
                              : (profile?.profileImage != null &&
                                    profile!.profileImage!.isNotEmpty)
                              ? NetworkImage(
                                  "http://10.0.2.2:2000${profile.profileImage}",
                                )
                              : AssetImage("assets/images/healthy.jpg")
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profile?.fullName ?? "Name",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          await ref
                              .read(authViewModelProvider.notifier)
                              .logout();
                          if (mounted) {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Personal Information",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(128),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Phone
                  _editableRow(
                    label: "Full Name",
                    value: profile?.fullName ?? "Enter Name",
                    onEdit: () {
                      _showEditDialog(
                        title: "Full Name",
                        initialValue: profile?.fullName ?? "",
                        keyboardType: TextInputType.text,
                        onSave: (value) {
                          ref
                              .read(consumerProfileViewmodelProvider.notifier)
                              .updateProfile(
                                UpdateConsumerProfileUsecaseParams(
                                  fullName: value,
                                ),
                              );
                        },
                      );
                    },
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Email
                  _editableRow(
                    label: "Email",
                    value: profile?.email ?? "Enter email",
                    onEdit: () {
                      _showEditDialog(
                        title: "Email",
                        initialValue: profile?.email ?? "",
                        keyboardType: TextInputType.emailAddress,
                        onSave: (value) {
                          ref
                              .read(consumerProfileViewmodelProvider.notifier)
                              .updateProfile(
                                UpdateConsumerProfileUsecaseParams(
                                  email: value,
                                ),
                              );
                        },
                      );
                    },
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Phone
                  _editableRow(
                    label: "Phone Number",
                    value: "+977 ${profile?.phoneNumber ?? "Enter number"}",
                    onEdit: () {
                      _showEditDialog(
                        title: "Phone Number",
                        initialValue: profile?.phoneNumber ?? "",
                        keyboardType: TextInputType.phone,
                        onSave: (value) {
                          ref
                              .read(consumerProfileViewmodelProvider.notifier)
                              .updateProfile(
                                UpdateConsumerProfileUsecaseParams(
                                  phoneNumber: value,
                                ),
                              );
                        },
                      );
                    },
                  ),
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _editableRow(
                    label: "Location",
                    value: profile?.location ?? "Enter location",
                    onEdit: () {
                      _showEditDialog(
                        title: "Location",
                        initialValue: profile?.location ?? "",
                        keyboardType: TextInputType.text,
                        onSave: (value) {
                          ref
                              .read(consumerProfileViewmodelProvider.notifier)
                              .updateProfile(
                                UpdateConsumerProfileUsecaseParams(
                                  location: value,
                                ),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Orders",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(128),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.image),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Product: Potato"), Text("2026-1-23")],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivered",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          Text("Price: 120"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
