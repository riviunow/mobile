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
  static double getFontSize(MaterialType type) {
    switch (type) {
      case MaterialType.textSmall || MaterialType.subtitle:
        return 16;
      case MaterialType.textMedium:
        return 20;
      case MaterialType.textLarge:
        return 24;
      default:
        return 16;
    }
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
}
