enum TargetPreset {
  feminine('feminine'),
  androgynous('androgynous'),
  masculine('masculine'),
  custom('custom');

  const TargetPreset(this.storageValue);

  final String storageValue;

  static TargetPreset fromStorage(String value) {
    return TargetPreset.values.firstWhere(
      (preset) => preset.storageValue == value,
      orElse: () => TargetPreset.custom,
    );
  }
}

class VoiceTarget {
  const VoiceTarget({
    required this.id,
    required this.targetHz,
    this.targetVolumeDbfs,
    required this.suggestionPreset,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final double targetHz;
  final double? targetVolumeDbfs;
  final TargetPreset suggestionPreset;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  VoiceTarget copyWith({
    String? id,
    double? targetHz,
    double? targetVolumeDbfs,
    TargetPreset? suggestionPreset,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return VoiceTarget(
      id: id ?? this.id,
      targetHz: targetHz ?? this.targetHz,
      targetVolumeDbfs: targetVolumeDbfs ?? this.targetVolumeDbfs,
      suggestionPreset: suggestionPreset ?? this.suggestionPreset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  String formatWithTolerance(int toleranceHz) {
    return '${targetHz.round()} Hz ± $toleranceHz Hz';
  }

  String? formatVolumeWithTolerance(int toleranceDb) {
    final value = targetVolumeDbfs;
    if (value == null) {
      return null;
    }
    return '${value.round()} dBFS ± $toleranceDb dB';
  }
}

const presetTargetSuggestions = <TargetPreset, double>{
  TargetPreset.feminine: 193,
  TargetPreset.androgynous: 160,
  TargetPreset.masculine: 123,
};

const presetReferenceBands = <TargetPreset, ({double minHz, double maxHz})>{
  TargetPreset.masculine: (minHz: 100, maxHz: 145),
  TargetPreset.androgynous: (minHz: 145, maxHz: 175),
  TargetPreset.feminine: (minHz: 165, maxHz: 220),
};
