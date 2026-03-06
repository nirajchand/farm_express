import 'dart:io';

import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/core/utils/snackbar_utils.dart';
import 'package:farm_express/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:farm_express/features/consumer_profile/domain/usecases/update_consumer_profile_usecase.dart';
import 'package:farm_express/features/consumer_profile/presentation/state/consumer_profile_state.dart';
import 'package:farm_express/features/consumer_profile/presentation/view_model/consumer_profile_viewmodel.dart';
import 'package:farm_express/features/order/domain/entities/order_entity.dart';
import 'package:farm_express/features/order/presentation/consumer/state/order_state.dart';
import 'package:farm_express/features/order/presentation/consumer/viewmodel/order_view_model.dart';
import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:farm_express/theme/app_colors.dart';
import 'package:farm_express/theme/theme_provider.dart';
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
      ref.read(orderViewModelProvider.notifier).fetchOrders();
    });
  }

  final List<XFile> _selectedMedia = [];
  String _orderFilter = "All";

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
      context: this.context,
      builder: (BuildContext ctx) => AlertDialog(
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
          await ref
              .read(consumerProfileViewmodelProvider.notifier)
              .updateProfile(
                UpdateConsumerProfileUsecaseParams(
                  profileImage: File(image.path),
                ),
              );
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        SnackbarUtils.showError(
          this.context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: this.context,
      backgroundColor: kWhiteback,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _useCameraForPhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
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
      context: this.context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: "Enter $title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(ctx);
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
    required Color textColor,
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

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    final now = DateTime.now();

    switch (_orderFilter) {
      case "Daily":
        return orders.where((order) {
          final created = order.createdAt;
          return created != null &&
              created.year == now.year &&
              created.month == now.month &&
              created.day == now.day;
        }).toList();

      case "Monthly":
        return orders.where((order) {
          final created = order.createdAt;
          return created != null &&
              created.year == now.year &&
              created.month == now.month;
        }).toList();

      case "All":
      default:
        return orders;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColorsDark() : AppColorsLight() as dynamic;
    final profileState = ref.watch(consumerProfileViewmodelProvider);
    final orderState = ref.watch(orderViewModelProvider);

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
            // ─── Top Header with Profile Image and Menu ───────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Image on Left
                  GestureDetector(
                    onTap: () {
                      _pickMedia();
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: _selectedMedia.isNotEmpty
                              ? FileImage(File(_selectedMedia.first.path))
                              : (profile?.profileImage != null &&
                                    profile!.profileImage!.isNotEmpty)
                              ? NetworkImage(
                                  ApiEndpoints.serverUrl +
                                      profile.profileImage!,
                                )
                              : AssetImage("assets/images/healthy.jpg")
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
                            child: Icon(
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
                        profile?.fullName ?? "Name",
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                  builder: (context) => ChooseRoleScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: Icon(
                            Icons.exit_to_app,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
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
                    color: colors.textPrimary,
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
                    textColor: colors.textPrimary,
                    onEdit: () {
                      _showEditDialog(
                        title: "Full Name",
                        initialValue: profile?.fullName ?? "",
                        keyboardType: TextInputType.text,
                        onSave: (value) {
                          final trimmed = value.trim();
                          if (trimmed.isEmpty) {
                            return;
                          }
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
                    textColor: colors.textPrimary,
                    onEdit: () {
                      _showEditDialog(
                        title: "Email",
                        initialValue: profile?.email ?? "",
                        keyboardType: TextInputType.emailAddress,
                        onSave: (value) {
                          final trimmed = value.trim();
                          if (trimmed.isEmpty) {
                            return;
                          }
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
                    textColor: colors.textPrimary,
                    onEdit: () {
                      _showEditDialog(
                        title: "Phone Number",
                        initialValue: profile?.phoneNumber ?? "",
                        keyboardType: TextInputType.phone,
                        onSave: (value) {
                          final trimmed = value.trim();
                          if (trimmed.isEmpty) {
                            return;
                          }
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
                    textColor: colors.textPrimary,
                    onEdit: () {
                      _showEditDialog(
                        title: "Location",
                        initialValue: profile?.location ?? "",
                        keyboardType: TextInputType.text,
                        onSave: (value) {
                          final trimmed = value.trim();
                          if (trimmed.isEmpty) {
                            return;
                          }
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
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Orders",
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                  value: _orderFilter,
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "Daily", child: Text("Daily")),
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _orderFilter = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              height: 300,
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
              child: switch (orderState.status) {
                OrderStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                OrderStatus.failure => Center(
                  child: Text(
                    orderState.errorMessage ?? "Failed to load orders",
                  ),
                ),
                OrderStatus.success when orderState.orders.isEmpty =>
                  const Center(child: Text("No orders yet")),
                _ => ListView.separated(
                  itemCount: _filterOrders(orderState.orders).length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final order = _filterOrders(orderState.orders)[index];
                    return _ProfileOrderTile(
                      order: order,
                      isDark: isDark,
                      colors: colors,
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOrderTile extends StatelessWidget {
  final OrderEntity order;
  final bool isDark;
  final dynamic colors;

  const _ProfileOrderTile({
    required this.order,
    required this.isDark,
    required this.colors,
  });

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return colors.warning;
      case 'accepted':
        return colors.info;
      case 'shipped':
        return colors.shipped;
      case 'delivered':
        return colors.success;
      case 'cancelled':
        return colors.error;
      default:
        return colors.textSecondary;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus ?? "Pending";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.success.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Order ID and Status
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id != null && order.id!.length >= 6
                      ? 'Order #${order.id!.substring(order.id!.length - 6).toUpperCase()}'
                      : 'Order',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: Price and Date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs ${order.totalAmount ?? 0}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(order.createdAt),
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
