import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const _mono = 'JetBrainsMono';

  // === DISPLAY (angka besar) ===
  static const displayLarge = TextStyle(
    fontFamily: _mono,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const displayMedium = TextStyle(
    fontFamily: _mono,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // === HEADING (label terminal style) ===
  static const headingLarge = TextStyle(
    fontFamily: _mono,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  static const headingMedium = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 2.0,
  );

  // === BODY ===
  static const bodyLarge = TextStyle(
    fontFamily: _mono,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // === LABEL ===
  static const labelMedium = TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: _mono,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 1.0,
  );

  // === AMOUNT (income/expense) ===
  static TextStyle amount({required bool isExpense, double size = 15}) =>
      TextStyle(
        fontFamily: _mono,
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: isExpense ? AppColors.expense : AppColors.income,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
