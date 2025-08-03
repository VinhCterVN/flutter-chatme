import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00696d),
      surfaceTint: Color(0xff00696d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9cf0f5),
      onPrimaryContainer: Color(0xff004f53),
      secondary: Color(0xff4a6364),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcce8e9),
      onSecondaryContainer: Color(0xff324b4c),
      tertiary: Color(0xff4e5f7d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd5e3ff),
      onTertiaryContainer: Color(0xff364764),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff161d1d),
      onSurfaceVariant: Color(0xff3f4949),
      outline: Color(0xff6f7979),
      outlineVariant: Color(0xffbec8c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4d9),
      primaryFixed: Color(0xff9cf0f5),
      onPrimaryFixed: Color(0xff002021),
      primaryFixedDim: Color(0xff80d4d9),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xffcce8e9),
      onSecondaryFixed: Color(0xff041f21),
      secondaryFixedDim: Color(0xffb1cccd),
      onSecondaryFixedVariant: Color(0xff324b4c),
      tertiaryFixed: Color(0xffd5e3ff),
      onTertiaryFixed: Color(0xff081c36),
      tertiaryFixedDim: Color(0xffb5c7e9),
      onTertiaryFixedVariant: Color(0xff364764),
      surfaceDim: Color(0xffd5dbdb),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe9efef),
      surfaceContainerHigh: Color(0xffe3e9e9),
      surfaceContainerHighest: Color(0xffdde4e4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003d40),
      surfaceTint: Color(0xff00696d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff16797d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff213a3c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff587273),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff253752),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5c6e8c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff2e3838),
      outline: Color(0xff4b5455),
      outlineVariant: Color(0xff656f6f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4d9),
      primaryFixed: Color(0xff16797d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005f63),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff587273),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff40595a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5c6e8c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff445572),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c8),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe3e9e9),
      surfaceContainerHigh: Color(0xffd8dede),
      surfaceContainerHighest: Color(0xffccd3d3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003234),
      surfaceTint: Color(0xff00696d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005255),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff173031),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff354d4f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b2c47),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff384a66),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbfa),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e2e),
      outlineVariant: Color(0xff414b4b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4d9),
      primaryFixed: Color(0xff005255),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00393c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff354d4f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1e3738),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff384a66),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff21334e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4baba),
      surfaceBright: Color(0xfff4fbfa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f2),
      surfaceContainer: Color(0xffdde4e4),
      surfaceContainerHigh: Color(0xffcfd6d5),
      surfaceContainerHighest: Color(0xffc1c8c8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d4d9),
      surfaceTint: Color(0xff80d4d9),
      onPrimary: Color(0xff003739),
      primaryContainer: Color(0xff004f53),
      onPrimaryContainer: Color(0xff9cf0f5),
      secondary: Color(0xffb1cccd),
      onSecondary: Color(0xff1b3436),
      secondaryContainer: Color(0xff324b4c),
      onSecondaryContainer: Color(0xffcce8e9),
      tertiary: Color(0xffb5c7e9),
      onTertiary: Color(0xff1f314c),
      tertiaryContainer: Color(0xff364764),
      onTertiaryContainer: Color(0xffd5e3ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdde4e4),
      onSurfaceVariant: Color(0xffbec8c9),
      outline: Color(0xff899393),
      outlineVariant: Color(0xff3f4949),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff00696d),
      primaryFixed: Color(0xff9cf0f5),
      onPrimaryFixed: Color(0xff002021),
      primaryFixedDim: Color(0xff80d4d9),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xffcce8e9),
      onSecondaryFixed: Color(0xff041f21),
      secondaryFixedDim: Color(0xffb1cccd),
      onSecondaryFixedVariant: Color(0xff324b4c),
      tertiaryFixed: Color(0xffd5e3ff),
      onTertiaryFixed: Color(0xff081c36),
      tertiaryFixedDim: Color(0xffb5c7e9),
      onTertiaryFixedVariant: Color(0xff364764),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff161d1d),
      surfaceContainer: Color(0xff1a2121),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff303636),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96eaef),
      surfaceTint: Color(0xff80d4d9),
      onPrimary: Color(0xff002b2d),
      primaryContainer: Color(0xff479da2),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6e2e3),
      onSecondary: Color(0xff10292b),
      secondaryContainer: Color(0xff7b9697),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffccddff),
      onTertiary: Color(0xff142640),
      tertiaryContainer: Color(0xff8091b1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dede),
      outline: Color(0xffaab4b4),
      outlineVariant: Color(0xff889293),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff005054),
      primaryFixed: Color(0xff9cf0f5),
      onPrimaryFixed: Color(0xff001415),
      primaryFixedDim: Color(0xff80d4d9),
      onPrimaryFixedVariant: Color(0xff003d40),
      secondaryFixed: Color(0xffcce8e9),
      onSecondaryFixed: Color(0xff001415),
      secondaryFixedDim: Color(0xffb1cccd),
      onSecondaryFixedVariant: Color(0xff213a3c),
      tertiaryFixed: Color(0xffd5e3ff),
      onTertiaryFixed: Color(0xff00112a),
      tertiaryFixedDim: Color(0xffb5c7e9),
      onTertiaryFixedVariant: Color(0xff253752),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4646),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff181f1f),
      surfaceContainer: Color(0xff232929),
      surfaceContainerHigh: Color(0xff2d3434),
      surfaceContainerHighest: Color(0xff383f3f),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbbfbff),
      surfaceTint: Color(0xff80d4d9),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff7cd0d5),
      onPrimaryContainer: Color(0xff000e0f),
      secondary: Color(0xffdaf5f7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffadc8c9),
      onSecondaryContainer: Color(0xff000e0f),
      tertiary: Color(0xffeaf0ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb2c3e5),
      onTertiaryContainer: Color(0xff000b1f),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f2),
      outlineVariant: Color(0xffbac5c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff005054),
      primaryFixed: Color(0xff9cf0f5),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff80d4d9),
      onPrimaryFixedVariant: Color(0xff001415),
      secondaryFixed: Color(0xffcce8e9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb1cccd),
      onSecondaryFixedVariant: Color(0xff001415),
      tertiaryFixed: Color(0xffd5e3ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb5c7e9),
      onTertiaryFixedVariant: Color(0xff00112a),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5151),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a2121),
      surfaceContainer: Color(0xff2b3232),
      surfaceContainerHigh: Color(0xff363d3d),
      surfaceContainerHighest: Color(0xff414848),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xff5981ff),
    value: Color(0xff5981ff),
    light: ColorFamily(
      color: Color(0xff4c5c92),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffdce1ff),
      onColorContainer: Color(0xff344479),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff4c5c92),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffdce1ff),
      onColorContainer: Color(0xff344479),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff4c5c92),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffdce1ff),
      onColorContainer: Color(0xff344479),
    ),
    dark: ColorFamily(
      color: Color(0xffb6c4ff),
      onColor: Color(0xff1d2d61),
      colorContainer: Color(0xff344479),
      onColorContainer: Color(0xffdce1ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffb6c4ff),
      onColor: Color(0xff1d2d61),
      colorContainer: Color(0xff344479),
      onColorContainer: Color(0xffdce1ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffb6c4ff),
      onColor: Color(0xff1d2d61),
      colorContainer: Color(0xff344479),
      onColorContainer: Color(0xffdce1ff),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    customColor1,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
