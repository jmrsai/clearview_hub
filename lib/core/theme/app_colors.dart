/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';

/// ClearView Hub — Glassmorphic Medical Color System
class AppColors {
  AppColors._();

  // ── Dark Mode Background ──────────────────────────────────────────────────
  static const Color bgDeep    = Color(0xFF030509); // Ultra-deep OLED black
  static const Color bgCard    = Color(0xFF0B111E); // Very subtle dark blue/grey
  static const Color bgSurface = Color(0xFF101728);

  // ── Light Mode Background ─────────────────────────────────────────────────
  static const Color bgLight      = Color(0xFFF8FAFC);
  static const Color bgLightCard  = Colors.white;
  static const Color bgLightAlt   = Color(0xFFF1F5F9);

  // ── Brand (Premium Neon) ──────────────────────────────────────────────────
  static const Color cyan      = Color(0xFF00F0FF); // Cyber neon cyan
  static const Color cyanDim   = Color(0x2200F0FF);
  static const Color cyanDeep  = Color(0xFF003882);
  static const Color violet    = Color(0xFFB026FF); // Neon violet
  static const Color violetDim = Color(0x22B026FF);
  static const Color teal      = Color(0xFF00E6A5);

  // ── Semantic ────────────────────────────────────────────────────────────────
  static const Color success   = Color(0xFF10B981);
  static const Color warning   = Color(0xFFF59E0B);
  static const Color error     = Color(0xFFF43F5E);
  static const Color info      = Color(0xFF3B82F6);

  // ── Dark Mode Text ─────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint      = Color(0xFF475569);

  // ── Light Mode Text ────────────────────────────────────────────────────────
  static const Color textLightPrimary   = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF475569);
  static const Color textLightHint      = Color(0xFF94A3B8);

  // ── Glass (Ultra-subtle) ──────────────────────────────────────────────────
  static const Color glassFill   = Color(0x0AFFFFFF); // Barely there fill
  static const Color glassBorder = Color(0x1AFFFFFF); // Sharp, thin border
  static const Color glassHighlight = Color(0x05FFFFFF);

  // ── Gradients ───────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF003882), Color(0xFF00F0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0B111E), Color(0xFF101728)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF064E3B), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFF78350F), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
