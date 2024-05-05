// lib/app_theme.dart
// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return LightModeTheme();
  }

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;
  late Color widgetBackground;

  late Color primaryBtnText;
  late Color lineColor;
  late Color grayIcon;
  late Color gray200;
  late Color gray600;
  late Color black600;
  late Color tertiary400;
  late Color textColor;
  late Color chipColor;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;
  String get title4Family => typography.title4Family;
  TextStyle get title4 => typography.title4;
  //for Community
  String get subtitle11Family => typography.subtitle11Family;
  TextStyle get subtitle11 => typography.subtitle11;
  String get subtitle22Family => typography.subtitle22Family;
  TextStyle get subtitle22 => typography.subtitle22;
  String get bodyText11Family => typography.bodyText11Family;
  TextStyle get bodyText11 => typography.bodyText11;
  String get bodyText22Family => typography.bodyText22Family;
  TextStyle get bodyText22 => typography.bodyText22;
  //////////////////////////////////////////////
  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  LightModeTheme() {
    primaryColor = Color(0xFFFC7562); // Bittersweet
    secondaryColor = Color(0xFFC0C0C4); // French gray
    tertiaryColor = Color(0xFFF4F4F4); // White smoke
    alternate = Color(0xFF181115); // Licorice

    primaryBackground = Color(0xFFF4F4F4); // White smoke
    secondaryBackground =
        Color(0xFFFC7562); // Bittersweet for highlight elements
    widgetBackground = Color(0xFFFFEDEB);
    // FFC8C2
    // FFEDEB

    primaryText = Color(0xFF181115); // Licorice
    secondaryText = Color(0xFFC0C0C4); // French gray

    primaryBtnText = Color(0xFFFFFFFF); // White for buttons text
    lineColor = Color(0xFFC0C0C4); // French gray for lines
    grayIcon = Color(0xFFC0C0C4); // French gray for icons
    gray200 = Color(0xFFC0C0C4); // Light gray for UI elements
    gray600 = Color(0xFF181115); // Dark gray nearly black
    black600 = Color(0xFF181115); // Black for text
    tertiary400 = Color(0xFFFC7562); // Bittersweet as an alternate color
    textColor = Color(0xFF181115);
    chipColor = Color(0xFFFC7562); // Main text color
  }
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
  String get title4Family;
  TextStyle get title4;
  //for community
  String get subtitle11Family;
  TextStyle get subtitle11;
  String get subtitle22Family;
  TextStyle get subtitle22;
  String get bodyText11Family;
  TextStyle get bodyText11;
  String get bodyText22Family;
  TextStyle get bodyText22;
///////////////////////////////
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  String get title1Family => 'Poppins';
  TextStyle get title1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title2Family => 'Poppins';
  TextStyle get title2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  String get title3Family => 'Poppins';
  TextStyle get title3 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Poppins';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  String get subtitle2Family => 'Poppins';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  String get bodyText1Family => 'Poppins';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  String get bodyText2Family => 'Poppins';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );

  String get title4Family => 'Poppins';
  TextStyle get title4 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 26,
        fontStyle: FontStyle.italic,
      );
  //for community
  String get subtitle11Family => 'Poppins';
  TextStyle get subtitle11 => GoogleFonts.getFont(
        'Poppins',
        fontSize: 18,
      );

  String get subtitle22Family => 'Poppins';
  TextStyle get subtitle22 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontSize: 16,
      );

  String get bodyText22Family => 'Poppins';
  TextStyle get bodyText22 => GoogleFonts.getFont(
        'Poppins',
        fontSize: 16,
      );

  String get bodyText11Family => 'Poppins';
  TextStyle get bodyText11 => GoogleFonts.getFont(
        'Poppins',
        fontSize: 12,
      );
///////////////////////////////////
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
