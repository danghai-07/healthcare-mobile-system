import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'doctor_avatar.dart';

/// Green hero header matching web `.profile-hero`.
class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.name,
    this.email,
    this.avatarUrl,
    this.gender,
  });

  final String name;
  final String? email;
  final String? avatarUrl;
  final String? gender;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: [
          DoctorAvatar(
            avatarUrl: avatarUrl,
            gender: gender,
            name: name,
            radius: 44,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (email != null && email!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              email!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
