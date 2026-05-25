import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === BACKGROUNDS ===
  static const bgPrimary = Color(0xFF1A1B2E);
  static const bgSurface = Color(0xFF16213E);
  static const bgCard = Color(0xFF0F3460);
  static const bgOverlay = Color(0xFF1E2035);
  static const bgInput = Color(0xFF0D1B38);

  // === ACCENTS ===
  static const blue = Color(0xFF7AA2F7);
  static const purple = Color(0xFFBB9AF7);
  static const cyan = Color(0xFF7DCFFF);
  static const green = Color(0xFF9ECE6A);
  static const red = Color(0xFFF7768E);
  static const orange = Color(0xFFFF9E64);
  static const yellow = Color(0xFFE0AF68);

  // === TEXT ===
  static const textPrimary = Color(0xFFC0CAF5);
  static const textMuted = Color(0xFF565F89);
  static const textDim = Color(0xFF3B4261);

  // === SEMANTIC ===
  static const income = green;
  static const expense = red;
  static const subscription = purple;
  static const pending = orange;
  static const settled = Color(0xFF565F89);

  // === BORDER ===
  static const border = Color(0x267AA2F7); // blue 15% opacity
  static const borderHover = Color(0x4D7AA2F7); // blue 30% opacity

  // === CATEGORY COLORS ===
  static const Map<String, Color> categoryColors = {
    'Makanan': orange,
    'Transport': cyan,
    'Belanja': yellow,
    'Hiburan': purple,
    'Tagihan': red,
    'Kesehatan': green,
    'Sains': Color(0xFF2AC3DE),
    'Lainnya': blue,
  };

  static Color forCategory(String name) => categoryColors[name] ?? blue;
}
