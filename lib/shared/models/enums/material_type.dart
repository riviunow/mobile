import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum MaterialType {
  subtitle,
  interpretation,
  textSmall,
  textMedium,
  textLarge,
  image,
  video,
  audio,
  unknown,
}

extension MaterialTypeExtension on MaterialType {
  static List<MaterialType> nonRestValues() {
    return [
      MaterialType.interpretation,
      MaterialType.textSmall,
      MaterialType.textMedium,
      MaterialType.textLarge,
      MaterialType.unknown,
    ];
  }

  static TextStyle getTextStyle(MaterialType type, BuildContext context) {
    double getFontSize(MaterialType type) {
      switch (type) {
        case MaterialType.textSmall:
        case MaterialType.subtitle:
          return 16;
        case MaterialType.textMedium:
          return 20;
        case MaterialType.textLarge:
          return 24;
        case MaterialType.interpretation:
          return 18;
        default:
          return 16;
      }
    }

    FontWeight getFontWeight(MaterialType type) {
      switch (type) {
        case MaterialType.textSmall:
        case MaterialType.subtitle:
          return FontWeight.w200;
        case MaterialType.textMedium:
          return FontWeight.bold;
        case MaterialType.textLarge:
          return FontWeight.bold;
        case MaterialType.interpretation:
          return FontWeight.normal;
        default:
          return FontWeight.normal;
      }
    }

    FontStyle getFontStyle(MaterialType type) {
      switch (type) {
        case MaterialType.textSmall:
          return FontStyle.italic;
        default:
          return FontStyle.normal;
      }
    }

    var fontSize = getFontSize(type);
    return TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).primaryColor,
      fontWeight: getFontWeight(type),
      fontStyle: getFontStyle(type),
    );
  }

  static MaterialType fromJson(String json) {
    switch (json) {
      case 'Subtitle':
        return MaterialType.subtitle;
      case 'Interpretation':
        return MaterialType.interpretation;
      case 'TextSmall':
        return MaterialType.textSmall;
      case 'TextMedium':
        return MaterialType.textMedium;
      case 'TextLarge':
        return MaterialType.textLarge;
      case 'Image':
        return MaterialType.image;
      case 'Video':
        return MaterialType.video;
      case 'Audio':
        return MaterialType.audio;
      case 'Unknown':
        return MaterialType.unknown;
      default:
        throw ArgumentError('Unknown material type: $json');
    }
  }

  String toJson() {
    switch (this) {
      case MaterialType.subtitle:
        return 'Subtitle';
      case MaterialType.interpretation:
        return 'Interpretation';
      case MaterialType.textSmall:
        return 'TextSmall';
      case MaterialType.textMedium:
        return 'TextMedium';
      case MaterialType.textLarge:
        return 'TextLarge';
      case MaterialType.image:
        return 'Image';
      case MaterialType.video:
        return 'Video';
      case MaterialType.audio:
        return 'Audio';
      case MaterialType.unknown:
        return 'Unknown';
    }
  }

  String toStr() {
    switch (this) {
      case MaterialType.subtitle:
        return 'material_type.subtitle'.tr();
      case MaterialType.interpretation:
        return 'material_type.interpretation'.tr();
      case MaterialType.textSmall:
        return 'material_type.textSmall'.tr();
      case MaterialType.textMedium:
        return 'material_type.textMedium'.tr();
      case MaterialType.textLarge:
        return 'material_type.textLarge'.tr();
      case MaterialType.image:
        return 'material_type.image'.tr();
      case MaterialType.video:
        return 'material_type.video'.tr();
      case MaterialType.audio:
        return 'material_type.audio'.tr();
      case MaterialType.unknown:
        return 'material_type.unknown'.tr();
    }
  }

  String getAcronym() {
    switch (this) {
      case MaterialType.subtitle:
        return 'Sub';
      case MaterialType.interpretation:
        return 'Int';
      case MaterialType.textSmall:
        return 'S';
      case MaterialType.textMedium:
        return 'M';
      case MaterialType.textLarge:
        return 'L';
      case MaterialType.image:
        return 'Img';
      case MaterialType.video:
        return 'Vid';
      case MaterialType.audio:
        return 'Aud';
      case MaterialType.unknown:
        return 'Unk';
    }
  }
}
