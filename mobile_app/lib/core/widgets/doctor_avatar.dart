import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Doctor avatar with network URL or gender-based default illustration.
class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({
    super.key,
    this.avatarUrl,
    this.gender,
    required this.name,
    this.radius = 28,
  });

  final String? avatarUrl;
  final String? gender;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final assetPath = _isFemale(gender, name)
        ? AppAssets.doctorFemale
        : AppAssets.doctorMale;
    final size = radius * 2;

    final url = avatarUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _assetImage(assetPath, size),
        ),
      );
    }

    return _assetImage(assetPath, size);
  }

  static Widget _assetImage(String path, double size) {
    return ClipOval(
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => CircleAvatar(
          radius: size / 2,
          backgroundColor: AppColors.primaryLight,
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primaryDark,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }

  static bool _isFemale(String? gender, String name) {
    final normalized = gender?.trim().toLowerCase() ?? '';
    if (normalized.contains('female') ||
        normalized.contains('nữ') ||
        normalized == 'f') {
      return true;
    }
    if (normalized.contains('male') ||
        normalized.contains('nam') ||
        normalized == 'm') {
      return false;
    }

    final lowerName = name.toLowerCase();
    return lowerName.contains(' thị ') ||
        lowerName.startsWith('thị ') ||
        lowerName.contains(' chị ') ||
        lowerName.contains(' cô ');
  }
}
