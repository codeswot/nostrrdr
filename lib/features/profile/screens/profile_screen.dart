import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/providers/theme_mode_provider.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/profile/providers/profile_provider.dart';
import 'package:nostrrdr/features/profile/widgets/key_section_card.dart';
import 'package:nostrrdr/features/profile/widgets/profile_avatar.dart';
import 'package:nostrrdr/features/profile/widgets/profile_edit_form.dart';
import 'package:nostrrdr/features/profile/widgets/profile_info_display.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isNsecVisible = false;

  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _nip05Controller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _nip05Controller.dispose();
    super.dispose();
  }

  void _startEditing(Profile? profile) {
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _aboutController.text = profile.about ?? '';
      _nip05Controller.text = profile.nip05 ?? '';
    }
    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _saveProfile() async {
    await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          name: _nameController.text,
          about: _aboutController.text,
          nip05: _nip05Controller.text,
        );
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final npub = ref.watch(currentNpubProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final profileAsync = ref.watch(profileProvider);
    final profileState = ref.watch(profileControllerProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _startEditing(profileAsync.value),
            )
          else
            IconButton(
              icon: profileState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              onPressed: profileState.isLoading ? null : _saveProfile,
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          const ProfileAvatar(),
          SizedBox(height: 24.h),

          if (_isEditing)
            ProfileEditForm(
              nameController: _nameController,
              aboutController: _aboutController,
              nip05Controller: _nip05Controller,
            )
          else
            profileAsync.when(
              data: (profile) => ProfileInfoDisplay(profile: profile),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Text('Failed to load profile'),
            ),

          SizedBox(height: 32.h),
          const Divider(),
          SizedBox(height: 16.h),

          // Theme Mode Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        color: theme.colorScheme.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Theme',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<AppThemeMode>(
                    value: currentThemeMode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: AppThemeMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(
                          mode.displayName,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (AppThemeMode? newMode) {
                      if (newMode != null) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(newMode);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Npub Section
          KeySectionCard(
            title: 'Public Key (npub)',
            value: npub,
            icon: Icons.key,
          ),
          SizedBox(height: 16.h),

          // Nsec Section
          FutureBuilder<String?>(
            future: authRepository.getAuthMethod(),
            builder: (context, snapshot) {
              if (snapshot.data != 'nsec') return const SizedBox.shrink();

              return FutureBuilder<String?>(
                future: authRepository.getNsec(),
                builder: (context, nsecSnapshot) {
                  return KeySectionCard(
                    title: 'Private Key (nsec)',
                    value: nsecSnapshot.data,
                    icon: Icons.lock,
                    isPrivate: true,
                    isVisible: _isNsecVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isNsecVisible = !_isNsecVisible;
                      });
                    },
                  );
                },
              );
            },
          ),

          SizedBox(height: 32.h),

          // Sign Out Button
          FilledButton.tonalIcon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  context.goNamed('auth');
                }
              }
            },
            icon: Icon(Icons.logout, size: 24.sp),
            label: Text('Sign Out', style: TextStyle(fontSize: 14.sp)),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ],
      ),
    );
  }
}
