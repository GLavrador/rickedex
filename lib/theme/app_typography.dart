import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle _base(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

  static TextStyle attribute(BuildContext context) => GoogleFonts.lato(
        textStyle: _base(context),
        color: AppColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 12.5,
        height: 1.0,
        letterSpacing: 0.0,
      );

  static TextStyle answer(BuildContext context) => GoogleFonts.lato(
        textStyle: _base(context),
        color: AppColors.white,
        fontWeight: FontWeight.w500,
        fontSize: 12.5,
        height: 1.0,
        letterSpacing: 0.0,
      );
}
