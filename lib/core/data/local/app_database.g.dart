// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VoiceTargetEntriesTable extends VoiceTargetEntries
    with TableInfo<$VoiceTargetEntriesTable, VoiceTargetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoiceTargetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetHzMeta = const VerificationMeta(
    'targetHz',
  );
  @override
  late final GeneratedColumn<double> targetHz = GeneratedColumn<double>(
    'target_hz',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetVolumeDbfsMeta = const VerificationMeta(
    'targetVolumeDbfs',
  );
  @override
  late final GeneratedColumn<double> targetVolumeDbfs = GeneratedColumn<double>(
    'target_volume_dbfs',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestionPresetMeta = const VerificationMeta(
    'suggestionPreset',
  );
  @override
  late final GeneratedColumn<String> suggestionPreset = GeneratedColumn<String>(
    'suggestion_preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetHz,
    targetVolumeDbfs,
    suggestionPreset,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_target_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoiceTargetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target_hz')) {
      context.handle(
        _targetHzMeta,
        targetHz.isAcceptableOrUnknown(data['target_hz']!, _targetHzMeta),
      );
    } else if (isInserting) {
      context.missing(_targetHzMeta);
    }
    if (data.containsKey('target_volume_dbfs')) {
      context.handle(
        _targetVolumeDbfsMeta,
        targetVolumeDbfs.isAcceptableOrUnknown(
          data['target_volume_dbfs']!,
          _targetVolumeDbfsMeta,
        ),
      );
    }
    if (data.containsKey('suggestion_preset')) {
      context.handle(
        _suggestionPresetMeta,
        suggestionPreset.isAcceptableOrUnknown(
          data['suggestion_preset']!,
          _suggestionPresetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suggestionPresetMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoiceTargetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoiceTargetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_hz'],
      )!,
      targetVolumeDbfs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_volume_dbfs'],
      ),
      suggestionPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggestion_preset'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $VoiceTargetEntriesTable createAlias(String alias) {
    return $VoiceTargetEntriesTable(attachedDatabase, alias);
  }
}

class VoiceTargetEntry extends DataClass
    implements Insertable<VoiceTargetEntry> {
  final String id;
  final double targetHz;
  final double? targetVolumeDbfs;
  final String suggestionPreset;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const VoiceTargetEntry({
    required this.id,
    required this.targetHz,
    this.targetVolumeDbfs,
    required this.suggestionPreset,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_hz'] = Variable<double>(targetHz);
    if (!nullToAbsent || targetVolumeDbfs != null) {
      map['target_volume_dbfs'] = Variable<double>(targetVolumeDbfs);
    }
    map['suggestion_preset'] = Variable<String>(suggestionPreset);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  VoiceTargetEntriesCompanion toCompanion(bool nullToAbsent) {
    return VoiceTargetEntriesCompanion(
      id: Value(id),
      targetHz: Value(targetHz),
      targetVolumeDbfs: targetVolumeDbfs == null && nullToAbsent
          ? const Value.absent()
          : Value(targetVolumeDbfs),
      suggestionPreset: Value(suggestionPreset),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory VoiceTargetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoiceTargetEntry(
      id: serializer.fromJson<String>(json['id']),
      targetHz: serializer.fromJson<double>(json['targetHz']),
      targetVolumeDbfs: serializer.fromJson<double?>(json['targetVolumeDbfs']),
      suggestionPreset: serializer.fromJson<String>(json['suggestionPreset']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetHz': serializer.toJson<double>(targetHz),
      'targetVolumeDbfs': serializer.toJson<double?>(targetVolumeDbfs),
      'suggestionPreset': serializer.toJson<String>(suggestionPreset),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  VoiceTargetEntry copyWith({
    String? id,
    double? targetHz,
    Value<double?> targetVolumeDbfs = const Value.absent(),
    String? suggestionPreset,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => VoiceTargetEntry(
    id: id ?? this.id,
    targetHz: targetHz ?? this.targetHz,
    targetVolumeDbfs: targetVolumeDbfs.present
        ? targetVolumeDbfs.value
        : this.targetVolumeDbfs,
    suggestionPreset: suggestionPreset ?? this.suggestionPreset,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  VoiceTargetEntry copyWithCompanion(VoiceTargetEntriesCompanion data) {
    return VoiceTargetEntry(
      id: data.id.present ? data.id.value : this.id,
      targetHz: data.targetHz.present ? data.targetHz.value : this.targetHz,
      targetVolumeDbfs: data.targetVolumeDbfs.present
          ? data.targetVolumeDbfs.value
          : this.targetVolumeDbfs,
      suggestionPreset: data.suggestionPreset.present
          ? data.suggestionPreset.value
          : this.suggestionPreset,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoiceTargetEntry(')
          ..write('id: $id, ')
          ..write('targetHz: $targetHz, ')
          ..write('targetVolumeDbfs: $targetVolumeDbfs, ')
          ..write('suggestionPreset: $suggestionPreset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetHz,
    targetVolumeDbfs,
    suggestionPreset,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoiceTargetEntry &&
          other.id == this.id &&
          other.targetHz == this.targetHz &&
          other.targetVolumeDbfs == this.targetVolumeDbfs &&
          other.suggestionPreset == this.suggestionPreset &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class VoiceTargetEntriesCompanion extends UpdateCompanion<VoiceTargetEntry> {
  final Value<String> id;
  final Value<double> targetHz;
  final Value<double?> targetVolumeDbfs;
  final Value<String> suggestionPreset;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const VoiceTargetEntriesCompanion({
    this.id = const Value.absent(),
    this.targetHz = const Value.absent(),
    this.targetVolumeDbfs = const Value.absent(),
    this.suggestionPreset = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoiceTargetEntriesCompanion.insert({
    required String id,
    required double targetHz,
    this.targetVolumeDbfs = const Value.absent(),
    required String suggestionPreset,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       targetHz = Value(targetHz),
       suggestionPreset = Value(suggestionPreset),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VoiceTargetEntry> custom({
    Expression<String>? id,
    Expression<double>? targetHz,
    Expression<double>? targetVolumeDbfs,
    Expression<String>? suggestionPreset,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetHz != null) 'target_hz': targetHz,
      if (targetVolumeDbfs != null) 'target_volume_dbfs': targetVolumeDbfs,
      if (suggestionPreset != null) 'suggestion_preset': suggestionPreset,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoiceTargetEntriesCompanion copyWith({
    Value<String>? id,
    Value<double>? targetHz,
    Value<double?>? targetVolumeDbfs,
    Value<String>? suggestionPreset,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return VoiceTargetEntriesCompanion(
      id: id ?? this.id,
      targetHz: targetHz ?? this.targetHz,
      targetVolumeDbfs: targetVolumeDbfs ?? this.targetVolumeDbfs,
      suggestionPreset: suggestionPreset ?? this.suggestionPreset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetHz.present) {
      map['target_hz'] = Variable<double>(targetHz.value);
    }
    if (targetVolumeDbfs.present) {
      map['target_volume_dbfs'] = Variable<double>(targetVolumeDbfs.value);
    }
    if (suggestionPreset.present) {
      map['suggestion_preset'] = Variable<String>(suggestionPreset.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoiceTargetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('targetHz: $targetHz, ')
          ..write('targetVolumeDbfs: $targetVolumeDbfs, ')
          ..write('suggestionPreset: $suggestionPreset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionEntriesTable extends PracticeSessionEntries
    with TableInfo<$PracticeSessionEntriesTable, PracticeSessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackingModeMeta = const VerificationMeta(
    'trackingMode',
  );
  @override
  late final GeneratedColumn<String> trackingMode = GeneratedColumn<String>(
    'tracking_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetHzMeta = const VerificationMeta(
    'targetHz',
  );
  @override
  late final GeneratedColumn<double> targetHz = GeneratedColumn<double>(
    'target_hz',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetVolumeDbfsMeta = const VerificationMeta(
    'targetVolumeDbfs',
  );
  @override
  late final GeneratedColumn<double> targetVolumeDbfs = GeneratedColumn<double>(
    'target_volume_dbfs',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetToleranceHzMeta = const VerificationMeta(
    'targetToleranceHz',
  );
  @override
  late final GeneratedColumn<int> targetToleranceHz = GeneratedColumn<int>(
    'target_tolerance_hz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetVolumeToleranceDbMeta =
      const VerificationMeta('targetVolumeToleranceDb');
  @override
  late final GeneratedColumn<int> targetVolumeToleranceDb =
      GeneratedColumn<int>(
        'target_volume_tolerance_db',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _targetSuggestionPresetMeta =
      const VerificationMeta('targetSuggestionPreset');
  @override
  late final GeneratedColumn<String> targetSuggestionPreset =
      GeneratedColumn<String>(
        'target_suggestion_preset',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _averagePitchHzMeta = const VerificationMeta(
    'averagePitchHz',
  );
  @override
  late final GeneratedColumn<double> averagePitchHz = GeneratedColumn<double>(
    'average_pitch_hz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minPitchHzMeta = const VerificationMeta(
    'minPitchHz',
  );
  @override
  late final GeneratedColumn<double> minPitchHz = GeneratedColumn<double>(
    'min_pitch_hz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPitchHzMeta = const VerificationMeta(
    'maxPitchHz',
  );
  @override
  late final GeneratedColumn<double> maxPitchHz = GeneratedColumn<double>(
    'max_pitch_hz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeAtTargetMsMeta = const VerificationMeta(
    'timeAtTargetMs',
  );
  @override
  late final GeneratedColumn<int> timeAtTargetMs = GeneratedColumn<int>(
    'time_at_target_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTrackedTimeMsMeta =
      const VerificationMeta('totalTrackedTimeMs');
  @override
  late final GeneratedColumn<int> totalTrackedTimeMs = GeneratedColumn<int>(
    'total_tracked_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioFilePathMeta = const VerificationMeta(
    'audioFilePath',
  );
  @override
  late final GeneratedColumn<String> audioFilePath = GeneratedColumn<String>(
    'audio_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chartPointsJsonMeta = const VerificationMeta(
    'chartPointsJson',
  );
  @override
  late final GeneratedColumn<String> chartPointsJson = GeneratedColumn<String>(
    'chart_points_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practiceTextIdMeta = const VerificationMeta(
    'practiceTextId',
  );
  @override
  late final GeneratedColumn<String> practiceTextId = GeneratedColumn<String>(
    'practice_text_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resonanceStateMeta = const VerificationMeta(
    'resonanceState',
  );
  @override
  late final GeneratedColumn<String> resonanceState = GeneratedColumn<String>(
    'resonance_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resonanceBalancedPercentMeta =
      const VerificationMeta('resonanceBalancedPercent');
  @override
  late final GeneratedColumn<double> resonanceBalancedPercent =
      GeneratedColumn<double>(
        'resonance_balanced_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _resonanceAverageConfidenceMeta =
      const VerificationMeta('resonanceAverageConfidence');
  @override
  late final GeneratedColumn<double> resonanceAverageConfidence =
      GeneratedColumn<double>(
        'resonance_average_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    updatedAt,
    mode,
    trackingMode,
    targetHz,
    targetVolumeDbfs,
    targetToleranceHz,
    targetVolumeToleranceDb,
    targetSuggestionPreset,
    averagePitchHz,
    minPitchHz,
    maxPitchHz,
    timeAtTargetMs,
    totalTrackedTimeMs,
    audioFilePath,
    chartPointsJson,
    practiceTextId,
    resonanceState,
    resonanceBalancedPercent,
    resonanceAverageConfidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_session_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeSessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('tracking_mode')) {
      context.handle(
        _trackingModeMeta,
        trackingMode.isAcceptableOrUnknown(
          data['tracking_mode']!,
          _trackingModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackingModeMeta);
    }
    if (data.containsKey('target_hz')) {
      context.handle(
        _targetHzMeta,
        targetHz.isAcceptableOrUnknown(data['target_hz']!, _targetHzMeta),
      );
    } else if (isInserting) {
      context.missing(_targetHzMeta);
    }
    if (data.containsKey('target_volume_dbfs')) {
      context.handle(
        _targetVolumeDbfsMeta,
        targetVolumeDbfs.isAcceptableOrUnknown(
          data['target_volume_dbfs']!,
          _targetVolumeDbfsMeta,
        ),
      );
    }
    if (data.containsKey('target_tolerance_hz')) {
      context.handle(
        _targetToleranceHzMeta,
        targetToleranceHz.isAcceptableOrUnknown(
          data['target_tolerance_hz']!,
          _targetToleranceHzMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetToleranceHzMeta);
    }
    if (data.containsKey('target_volume_tolerance_db')) {
      context.handle(
        _targetVolumeToleranceDbMeta,
        targetVolumeToleranceDb.isAcceptableOrUnknown(
          data['target_volume_tolerance_db']!,
          _targetVolumeToleranceDbMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetVolumeToleranceDbMeta);
    }
    if (data.containsKey('target_suggestion_preset')) {
      context.handle(
        _targetSuggestionPresetMeta,
        targetSuggestionPreset.isAcceptableOrUnknown(
          data['target_suggestion_preset']!,
          _targetSuggestionPresetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetSuggestionPresetMeta);
    }
    if (data.containsKey('average_pitch_hz')) {
      context.handle(
        _averagePitchHzMeta,
        averagePitchHz.isAcceptableOrUnknown(
          data['average_pitch_hz']!,
          _averagePitchHzMeta,
        ),
      );
    }
    if (data.containsKey('min_pitch_hz')) {
      context.handle(
        _minPitchHzMeta,
        minPitchHz.isAcceptableOrUnknown(
          data['min_pitch_hz']!,
          _minPitchHzMeta,
        ),
      );
    }
    if (data.containsKey('max_pitch_hz')) {
      context.handle(
        _maxPitchHzMeta,
        maxPitchHz.isAcceptableOrUnknown(
          data['max_pitch_hz']!,
          _maxPitchHzMeta,
        ),
      );
    }
    if (data.containsKey('time_at_target_ms')) {
      context.handle(
        _timeAtTargetMsMeta,
        timeAtTargetMs.isAcceptableOrUnknown(
          data['time_at_target_ms']!,
          _timeAtTargetMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeAtTargetMsMeta);
    }
    if (data.containsKey('total_tracked_time_ms')) {
      context.handle(
        _totalTrackedTimeMsMeta,
        totalTrackedTimeMs.isAcceptableOrUnknown(
          data['total_tracked_time_ms']!,
          _totalTrackedTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalTrackedTimeMsMeta);
    }
    if (data.containsKey('audio_file_path')) {
      context.handle(
        _audioFilePathMeta,
        audioFilePath.isAcceptableOrUnknown(
          data['audio_file_path']!,
          _audioFilePathMeta,
        ),
      );
    }
    if (data.containsKey('chart_points_json')) {
      context.handle(
        _chartPointsJsonMeta,
        chartPointsJson.isAcceptableOrUnknown(
          data['chart_points_json']!,
          _chartPointsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chartPointsJsonMeta);
    }
    if (data.containsKey('practice_text_id')) {
      context.handle(
        _practiceTextIdMeta,
        practiceTextId.isAcceptableOrUnknown(
          data['practice_text_id']!,
          _practiceTextIdMeta,
        ),
      );
    }
    if (data.containsKey('resonance_state')) {
      context.handle(
        _resonanceStateMeta,
        resonanceState.isAcceptableOrUnknown(
          data['resonance_state']!,
          _resonanceStateMeta,
        ),
      );
    }
    if (data.containsKey('resonance_balanced_percent')) {
      context.handle(
        _resonanceBalancedPercentMeta,
        resonanceBalancedPercent.isAcceptableOrUnknown(
          data['resonance_balanced_percent']!,
          _resonanceBalancedPercentMeta,
        ),
      );
    }
    if (data.containsKey('resonance_average_confidence')) {
      context.handle(
        _resonanceAverageConfidenceMeta,
        resonanceAverageConfidence.isAcceptableOrUnknown(
          data['resonance_average_confidence']!,
          _resonanceAverageConfidenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSessionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      trackingMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_mode'],
      )!,
      targetHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_hz'],
      )!,
      targetVolumeDbfs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_volume_dbfs'],
      ),
      targetToleranceHz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_tolerance_hz'],
      )!,
      targetVolumeToleranceDb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_volume_tolerance_db'],
      )!,
      targetSuggestionPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_suggestion_preset'],
      )!,
      averagePitchHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_pitch_hz'],
      ),
      minPitchHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_pitch_hz'],
      ),
      maxPitchHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_pitch_hz'],
      ),
      timeAtTargetMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_at_target_ms'],
      )!,
      totalTrackedTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tracked_time_ms'],
      )!,
      audioFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_file_path'],
      ),
      chartPointsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chart_points_json'],
      )!,
      practiceTextId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}practice_text_id'],
      ),
      resonanceState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resonance_state'],
      ),
      resonanceBalancedPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}resonance_balanced_percent'],
      ),
      resonanceAverageConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}resonance_average_confidence'],
      ),
    );
  }

  @override
  $PracticeSessionEntriesTable createAlias(String alias) {
    return $PracticeSessionEntriesTable(attachedDatabase, alias);
  }
}

class PracticeSessionEntry extends DataClass
    implements Insertable<PracticeSessionEntry> {
  final String id;
  final int startedAt;
  final int endedAt;
  final int updatedAt;
  final String mode;
  final String trackingMode;
  final double targetHz;
  final double? targetVolumeDbfs;
  final int targetToleranceHz;
  final int targetVolumeToleranceDb;
  final String targetSuggestionPreset;
  final double? averagePitchHz;
  final double? minPitchHz;
  final double? maxPitchHz;
  final int timeAtTargetMs;
  final int totalTrackedTimeMs;
  final String? audioFilePath;
  final String chartPointsJson;
  final String? practiceTextId;
  final String? resonanceState;
  final double? resonanceBalancedPercent;
  final double? resonanceAverageConfidence;
  const PracticeSessionEntry({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.mode,
    required this.trackingMode,
    required this.targetHz,
    this.targetVolumeDbfs,
    required this.targetToleranceHz,
    required this.targetVolumeToleranceDb,
    required this.targetSuggestionPreset,
    this.averagePitchHz,
    this.minPitchHz,
    this.maxPitchHz,
    required this.timeAtTargetMs,
    required this.totalTrackedTimeMs,
    this.audioFilePath,
    required this.chartPointsJson,
    this.practiceTextId,
    this.resonanceState,
    this.resonanceBalancedPercent,
    this.resonanceAverageConfidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<int>(startedAt);
    map['ended_at'] = Variable<int>(endedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['mode'] = Variable<String>(mode);
    map['tracking_mode'] = Variable<String>(trackingMode);
    map['target_hz'] = Variable<double>(targetHz);
    if (!nullToAbsent || targetVolumeDbfs != null) {
      map['target_volume_dbfs'] = Variable<double>(targetVolumeDbfs);
    }
    map['target_tolerance_hz'] = Variable<int>(targetToleranceHz);
    map['target_volume_tolerance_db'] = Variable<int>(targetVolumeToleranceDb);
    map['target_suggestion_preset'] = Variable<String>(targetSuggestionPreset);
    if (!nullToAbsent || averagePitchHz != null) {
      map['average_pitch_hz'] = Variable<double>(averagePitchHz);
    }
    if (!nullToAbsent || minPitchHz != null) {
      map['min_pitch_hz'] = Variable<double>(minPitchHz);
    }
    if (!nullToAbsent || maxPitchHz != null) {
      map['max_pitch_hz'] = Variable<double>(maxPitchHz);
    }
    map['time_at_target_ms'] = Variable<int>(timeAtTargetMs);
    map['total_tracked_time_ms'] = Variable<int>(totalTrackedTimeMs);
    if (!nullToAbsent || audioFilePath != null) {
      map['audio_file_path'] = Variable<String>(audioFilePath);
    }
    map['chart_points_json'] = Variable<String>(chartPointsJson);
    if (!nullToAbsent || practiceTextId != null) {
      map['practice_text_id'] = Variable<String>(practiceTextId);
    }
    if (!nullToAbsent || resonanceState != null) {
      map['resonance_state'] = Variable<String>(resonanceState);
    }
    if (!nullToAbsent || resonanceBalancedPercent != null) {
      map['resonance_balanced_percent'] = Variable<double>(
        resonanceBalancedPercent,
      );
    }
    if (!nullToAbsent || resonanceAverageConfidence != null) {
      map['resonance_average_confidence'] = Variable<double>(
        resonanceAverageConfidence,
      );
    }
    return map;
  }

  PracticeSessionEntriesCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionEntriesCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      updatedAt: Value(updatedAt),
      mode: Value(mode),
      trackingMode: Value(trackingMode),
      targetHz: Value(targetHz),
      targetVolumeDbfs: targetVolumeDbfs == null && nullToAbsent
          ? const Value.absent()
          : Value(targetVolumeDbfs),
      targetToleranceHz: Value(targetToleranceHz),
      targetVolumeToleranceDb: Value(targetVolumeToleranceDb),
      targetSuggestionPreset: Value(targetSuggestionPreset),
      averagePitchHz: averagePitchHz == null && nullToAbsent
          ? const Value.absent()
          : Value(averagePitchHz),
      minPitchHz: minPitchHz == null && nullToAbsent
          ? const Value.absent()
          : Value(minPitchHz),
      maxPitchHz: maxPitchHz == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPitchHz),
      timeAtTargetMs: Value(timeAtTargetMs),
      totalTrackedTimeMs: Value(totalTrackedTimeMs),
      audioFilePath: audioFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFilePath),
      chartPointsJson: Value(chartPointsJson),
      practiceTextId: practiceTextId == null && nullToAbsent
          ? const Value.absent()
          : Value(practiceTextId),
      resonanceState: resonanceState == null && nullToAbsent
          ? const Value.absent()
          : Value(resonanceState),
      resonanceBalancedPercent: resonanceBalancedPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(resonanceBalancedPercent),
      resonanceAverageConfidence:
          resonanceAverageConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(resonanceAverageConfidence),
    );
  }

  factory PracticeSessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSessionEntry(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int>(json['endedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      mode: serializer.fromJson<String>(json['mode']),
      trackingMode: serializer.fromJson<String>(json['trackingMode']),
      targetHz: serializer.fromJson<double>(json['targetHz']),
      targetVolumeDbfs: serializer.fromJson<double?>(json['targetVolumeDbfs']),
      targetToleranceHz: serializer.fromJson<int>(json['targetToleranceHz']),
      targetVolumeToleranceDb: serializer.fromJson<int>(
        json['targetVolumeToleranceDb'],
      ),
      targetSuggestionPreset: serializer.fromJson<String>(
        json['targetSuggestionPreset'],
      ),
      averagePitchHz: serializer.fromJson<double?>(json['averagePitchHz']),
      minPitchHz: serializer.fromJson<double?>(json['minPitchHz']),
      maxPitchHz: serializer.fromJson<double?>(json['maxPitchHz']),
      timeAtTargetMs: serializer.fromJson<int>(json['timeAtTargetMs']),
      totalTrackedTimeMs: serializer.fromJson<int>(json['totalTrackedTimeMs']),
      audioFilePath: serializer.fromJson<String?>(json['audioFilePath']),
      chartPointsJson: serializer.fromJson<String>(json['chartPointsJson']),
      practiceTextId: serializer.fromJson<String?>(json['practiceTextId']),
      resonanceState: serializer.fromJson<String?>(json['resonanceState']),
      resonanceBalancedPercent: serializer.fromJson<double?>(
        json['resonanceBalancedPercent'],
      ),
      resonanceAverageConfidence: serializer.fromJson<double?>(
        json['resonanceAverageConfidence'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int>(endedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'mode': serializer.toJson<String>(mode),
      'trackingMode': serializer.toJson<String>(trackingMode),
      'targetHz': serializer.toJson<double>(targetHz),
      'targetVolumeDbfs': serializer.toJson<double?>(targetVolumeDbfs),
      'targetToleranceHz': serializer.toJson<int>(targetToleranceHz),
      'targetVolumeToleranceDb': serializer.toJson<int>(
        targetVolumeToleranceDb,
      ),
      'targetSuggestionPreset': serializer.toJson<String>(
        targetSuggestionPreset,
      ),
      'averagePitchHz': serializer.toJson<double?>(averagePitchHz),
      'minPitchHz': serializer.toJson<double?>(minPitchHz),
      'maxPitchHz': serializer.toJson<double?>(maxPitchHz),
      'timeAtTargetMs': serializer.toJson<int>(timeAtTargetMs),
      'totalTrackedTimeMs': serializer.toJson<int>(totalTrackedTimeMs),
      'audioFilePath': serializer.toJson<String?>(audioFilePath),
      'chartPointsJson': serializer.toJson<String>(chartPointsJson),
      'practiceTextId': serializer.toJson<String?>(practiceTextId),
      'resonanceState': serializer.toJson<String?>(resonanceState),
      'resonanceBalancedPercent': serializer.toJson<double?>(
        resonanceBalancedPercent,
      ),
      'resonanceAverageConfidence': serializer.toJson<double?>(
        resonanceAverageConfidence,
      ),
    };
  }

  PracticeSessionEntry copyWith({
    String? id,
    int? startedAt,
    int? endedAt,
    int? updatedAt,
    String? mode,
    String? trackingMode,
    double? targetHz,
    Value<double?> targetVolumeDbfs = const Value.absent(),
    int? targetToleranceHz,
    int? targetVolumeToleranceDb,
    String? targetSuggestionPreset,
    Value<double?> averagePitchHz = const Value.absent(),
    Value<double?> minPitchHz = const Value.absent(),
    Value<double?> maxPitchHz = const Value.absent(),
    int? timeAtTargetMs,
    int? totalTrackedTimeMs,
    Value<String?> audioFilePath = const Value.absent(),
    String? chartPointsJson,
    Value<String?> practiceTextId = const Value.absent(),
    Value<String?> resonanceState = const Value.absent(),
    Value<double?> resonanceBalancedPercent = const Value.absent(),
    Value<double?> resonanceAverageConfidence = const Value.absent(),
  }) => PracticeSessionEntry(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    mode: mode ?? this.mode,
    trackingMode: trackingMode ?? this.trackingMode,
    targetHz: targetHz ?? this.targetHz,
    targetVolumeDbfs: targetVolumeDbfs.present
        ? targetVolumeDbfs.value
        : this.targetVolumeDbfs,
    targetToleranceHz: targetToleranceHz ?? this.targetToleranceHz,
    targetVolumeToleranceDb:
        targetVolumeToleranceDb ?? this.targetVolumeToleranceDb,
    targetSuggestionPreset:
        targetSuggestionPreset ?? this.targetSuggestionPreset,
    averagePitchHz: averagePitchHz.present
        ? averagePitchHz.value
        : this.averagePitchHz,
    minPitchHz: minPitchHz.present ? minPitchHz.value : this.minPitchHz,
    maxPitchHz: maxPitchHz.present ? maxPitchHz.value : this.maxPitchHz,
    timeAtTargetMs: timeAtTargetMs ?? this.timeAtTargetMs,
    totalTrackedTimeMs: totalTrackedTimeMs ?? this.totalTrackedTimeMs,
    audioFilePath: audioFilePath.present
        ? audioFilePath.value
        : this.audioFilePath,
    chartPointsJson: chartPointsJson ?? this.chartPointsJson,
    practiceTextId: practiceTextId.present
        ? practiceTextId.value
        : this.practiceTextId,
    resonanceState: resonanceState.present
        ? resonanceState.value
        : this.resonanceState,
    resonanceBalancedPercent: resonanceBalancedPercent.present
        ? resonanceBalancedPercent.value
        : this.resonanceBalancedPercent,
    resonanceAverageConfidence: resonanceAverageConfidence.present
        ? resonanceAverageConfidence.value
        : this.resonanceAverageConfidence,
  );
  PracticeSessionEntry copyWithCompanion(PracticeSessionEntriesCompanion data) {
    return PracticeSessionEntry(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      mode: data.mode.present ? data.mode.value : this.mode,
      trackingMode: data.trackingMode.present
          ? data.trackingMode.value
          : this.trackingMode,
      targetHz: data.targetHz.present ? data.targetHz.value : this.targetHz,
      targetVolumeDbfs: data.targetVolumeDbfs.present
          ? data.targetVolumeDbfs.value
          : this.targetVolumeDbfs,
      targetToleranceHz: data.targetToleranceHz.present
          ? data.targetToleranceHz.value
          : this.targetToleranceHz,
      targetVolumeToleranceDb: data.targetVolumeToleranceDb.present
          ? data.targetVolumeToleranceDb.value
          : this.targetVolumeToleranceDb,
      targetSuggestionPreset: data.targetSuggestionPreset.present
          ? data.targetSuggestionPreset.value
          : this.targetSuggestionPreset,
      averagePitchHz: data.averagePitchHz.present
          ? data.averagePitchHz.value
          : this.averagePitchHz,
      minPitchHz: data.minPitchHz.present
          ? data.minPitchHz.value
          : this.minPitchHz,
      maxPitchHz: data.maxPitchHz.present
          ? data.maxPitchHz.value
          : this.maxPitchHz,
      timeAtTargetMs: data.timeAtTargetMs.present
          ? data.timeAtTargetMs.value
          : this.timeAtTargetMs,
      totalTrackedTimeMs: data.totalTrackedTimeMs.present
          ? data.totalTrackedTimeMs.value
          : this.totalTrackedTimeMs,
      audioFilePath: data.audioFilePath.present
          ? data.audioFilePath.value
          : this.audioFilePath,
      chartPointsJson: data.chartPointsJson.present
          ? data.chartPointsJson.value
          : this.chartPointsJson,
      practiceTextId: data.practiceTextId.present
          ? data.practiceTextId.value
          : this.practiceTextId,
      resonanceState: data.resonanceState.present
          ? data.resonanceState.value
          : this.resonanceState,
      resonanceBalancedPercent: data.resonanceBalancedPercent.present
          ? data.resonanceBalancedPercent.value
          : this.resonanceBalancedPercent,
      resonanceAverageConfidence: data.resonanceAverageConfidence.present
          ? data.resonanceAverageConfidence.value
          : this.resonanceAverageConfidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionEntry(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('mode: $mode, ')
          ..write('trackingMode: $trackingMode, ')
          ..write('targetHz: $targetHz, ')
          ..write('targetVolumeDbfs: $targetVolumeDbfs, ')
          ..write('targetToleranceHz: $targetToleranceHz, ')
          ..write('targetVolumeToleranceDb: $targetVolumeToleranceDb, ')
          ..write('targetSuggestionPreset: $targetSuggestionPreset, ')
          ..write('averagePitchHz: $averagePitchHz, ')
          ..write('minPitchHz: $minPitchHz, ')
          ..write('maxPitchHz: $maxPitchHz, ')
          ..write('timeAtTargetMs: $timeAtTargetMs, ')
          ..write('totalTrackedTimeMs: $totalTrackedTimeMs, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('chartPointsJson: $chartPointsJson, ')
          ..write('practiceTextId: $practiceTextId, ')
          ..write('resonanceState: $resonanceState, ')
          ..write('resonanceBalancedPercent: $resonanceBalancedPercent, ')
          ..write('resonanceAverageConfidence: $resonanceAverageConfidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    startedAt,
    endedAt,
    updatedAt,
    mode,
    trackingMode,
    targetHz,
    targetVolumeDbfs,
    targetToleranceHz,
    targetVolumeToleranceDb,
    targetSuggestionPreset,
    averagePitchHz,
    minPitchHz,
    maxPitchHz,
    timeAtTargetMs,
    totalTrackedTimeMs,
    audioFilePath,
    chartPointsJson,
    practiceTextId,
    resonanceState,
    resonanceBalancedPercent,
    resonanceAverageConfidence,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSessionEntry &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.updatedAt == this.updatedAt &&
          other.mode == this.mode &&
          other.trackingMode == this.trackingMode &&
          other.targetHz == this.targetHz &&
          other.targetVolumeDbfs == this.targetVolumeDbfs &&
          other.targetToleranceHz == this.targetToleranceHz &&
          other.targetVolumeToleranceDb == this.targetVolumeToleranceDb &&
          other.targetSuggestionPreset == this.targetSuggestionPreset &&
          other.averagePitchHz == this.averagePitchHz &&
          other.minPitchHz == this.minPitchHz &&
          other.maxPitchHz == this.maxPitchHz &&
          other.timeAtTargetMs == this.timeAtTargetMs &&
          other.totalTrackedTimeMs == this.totalTrackedTimeMs &&
          other.audioFilePath == this.audioFilePath &&
          other.chartPointsJson == this.chartPointsJson &&
          other.practiceTextId == this.practiceTextId &&
          other.resonanceState == this.resonanceState &&
          other.resonanceBalancedPercent == this.resonanceBalancedPercent &&
          other.resonanceAverageConfidence == this.resonanceAverageConfidence);
}

class PracticeSessionEntriesCompanion
    extends UpdateCompanion<PracticeSessionEntry> {
  final Value<String> id;
  final Value<int> startedAt;
  final Value<int> endedAt;
  final Value<int> updatedAt;
  final Value<String> mode;
  final Value<String> trackingMode;
  final Value<double> targetHz;
  final Value<double?> targetVolumeDbfs;
  final Value<int> targetToleranceHz;
  final Value<int> targetVolumeToleranceDb;
  final Value<String> targetSuggestionPreset;
  final Value<double?> averagePitchHz;
  final Value<double?> minPitchHz;
  final Value<double?> maxPitchHz;
  final Value<int> timeAtTargetMs;
  final Value<int> totalTrackedTimeMs;
  final Value<String?> audioFilePath;
  final Value<String> chartPointsJson;
  final Value<String?> practiceTextId;
  final Value<String?> resonanceState;
  final Value<double?> resonanceBalancedPercent;
  final Value<double?> resonanceAverageConfidence;
  final Value<int> rowid;
  const PracticeSessionEntriesCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.mode = const Value.absent(),
    this.trackingMode = const Value.absent(),
    this.targetHz = const Value.absent(),
    this.targetVolumeDbfs = const Value.absent(),
    this.targetToleranceHz = const Value.absent(),
    this.targetVolumeToleranceDb = const Value.absent(),
    this.targetSuggestionPreset = const Value.absent(),
    this.averagePitchHz = const Value.absent(),
    this.minPitchHz = const Value.absent(),
    this.maxPitchHz = const Value.absent(),
    this.timeAtTargetMs = const Value.absent(),
    this.totalTrackedTimeMs = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.chartPointsJson = const Value.absent(),
    this.practiceTextId = const Value.absent(),
    this.resonanceState = const Value.absent(),
    this.resonanceBalancedPercent = const Value.absent(),
    this.resonanceAverageConfidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeSessionEntriesCompanion.insert({
    required String id,
    required int startedAt,
    required int endedAt,
    required int updatedAt,
    required String mode,
    required String trackingMode,
    required double targetHz,
    this.targetVolumeDbfs = const Value.absent(),
    required int targetToleranceHz,
    required int targetVolumeToleranceDb,
    required String targetSuggestionPreset,
    this.averagePitchHz = const Value.absent(),
    this.minPitchHz = const Value.absent(),
    this.maxPitchHz = const Value.absent(),
    required int timeAtTargetMs,
    required int totalTrackedTimeMs,
    this.audioFilePath = const Value.absent(),
    required String chartPointsJson,
    this.practiceTextId = const Value.absent(),
    this.resonanceState = const Value.absent(),
    this.resonanceBalancedPercent = const Value.absent(),
    this.resonanceAverageConfidence = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       updatedAt = Value(updatedAt),
       mode = Value(mode),
       trackingMode = Value(trackingMode),
       targetHz = Value(targetHz),
       targetToleranceHz = Value(targetToleranceHz),
       targetVolumeToleranceDb = Value(targetVolumeToleranceDb),
       targetSuggestionPreset = Value(targetSuggestionPreset),
       timeAtTargetMs = Value(timeAtTargetMs),
       totalTrackedTimeMs = Value(totalTrackedTimeMs),
       chartPointsJson = Value(chartPointsJson);
  static Insertable<PracticeSessionEntry> custom({
    Expression<String>? id,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<int>? updatedAt,
    Expression<String>? mode,
    Expression<String>? trackingMode,
    Expression<double>? targetHz,
    Expression<double>? targetVolumeDbfs,
    Expression<int>? targetToleranceHz,
    Expression<int>? targetVolumeToleranceDb,
    Expression<String>? targetSuggestionPreset,
    Expression<double>? averagePitchHz,
    Expression<double>? minPitchHz,
    Expression<double>? maxPitchHz,
    Expression<int>? timeAtTargetMs,
    Expression<int>? totalTrackedTimeMs,
    Expression<String>? audioFilePath,
    Expression<String>? chartPointsJson,
    Expression<String>? practiceTextId,
    Expression<String>? resonanceState,
    Expression<double>? resonanceBalancedPercent,
    Expression<double>? resonanceAverageConfidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (mode != null) 'mode': mode,
      if (trackingMode != null) 'tracking_mode': trackingMode,
      if (targetHz != null) 'target_hz': targetHz,
      if (targetVolumeDbfs != null) 'target_volume_dbfs': targetVolumeDbfs,
      if (targetToleranceHz != null) 'target_tolerance_hz': targetToleranceHz,
      if (targetVolumeToleranceDb != null)
        'target_volume_tolerance_db': targetVolumeToleranceDb,
      if (targetSuggestionPreset != null)
        'target_suggestion_preset': targetSuggestionPreset,
      if (averagePitchHz != null) 'average_pitch_hz': averagePitchHz,
      if (minPitchHz != null) 'min_pitch_hz': minPitchHz,
      if (maxPitchHz != null) 'max_pitch_hz': maxPitchHz,
      if (timeAtTargetMs != null) 'time_at_target_ms': timeAtTargetMs,
      if (totalTrackedTimeMs != null)
        'total_tracked_time_ms': totalTrackedTimeMs,
      if (audioFilePath != null) 'audio_file_path': audioFilePath,
      if (chartPointsJson != null) 'chart_points_json': chartPointsJson,
      if (practiceTextId != null) 'practice_text_id': practiceTextId,
      if (resonanceState != null) 'resonance_state': resonanceState,
      if (resonanceBalancedPercent != null)
        'resonance_balanced_percent': resonanceBalancedPercent,
      if (resonanceAverageConfidence != null)
        'resonance_average_confidence': resonanceAverageConfidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeSessionEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAt,
    Value<int>? endedAt,
    Value<int>? updatedAt,
    Value<String>? mode,
    Value<String>? trackingMode,
    Value<double>? targetHz,
    Value<double?>? targetVolumeDbfs,
    Value<int>? targetToleranceHz,
    Value<int>? targetVolumeToleranceDb,
    Value<String>? targetSuggestionPreset,
    Value<double?>? averagePitchHz,
    Value<double?>? minPitchHz,
    Value<double?>? maxPitchHz,
    Value<int>? timeAtTargetMs,
    Value<int>? totalTrackedTimeMs,
    Value<String?>? audioFilePath,
    Value<String>? chartPointsJson,
    Value<String?>? practiceTextId,
    Value<String?>? resonanceState,
    Value<double?>? resonanceBalancedPercent,
    Value<double?>? resonanceAverageConfidence,
    Value<int>? rowid,
  }) {
    return PracticeSessionEntriesCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mode: mode ?? this.mode,
      trackingMode: trackingMode ?? this.trackingMode,
      targetHz: targetHz ?? this.targetHz,
      targetVolumeDbfs: targetVolumeDbfs ?? this.targetVolumeDbfs,
      targetToleranceHz: targetToleranceHz ?? this.targetToleranceHz,
      targetVolumeToleranceDb:
          targetVolumeToleranceDb ?? this.targetVolumeToleranceDb,
      targetSuggestionPreset:
          targetSuggestionPreset ?? this.targetSuggestionPreset,
      averagePitchHz: averagePitchHz ?? this.averagePitchHz,
      minPitchHz: minPitchHz ?? this.minPitchHz,
      maxPitchHz: maxPitchHz ?? this.maxPitchHz,
      timeAtTargetMs: timeAtTargetMs ?? this.timeAtTargetMs,
      totalTrackedTimeMs: totalTrackedTimeMs ?? this.totalTrackedTimeMs,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      chartPointsJson: chartPointsJson ?? this.chartPointsJson,
      practiceTextId: practiceTextId ?? this.practiceTextId,
      resonanceState: resonanceState ?? this.resonanceState,
      resonanceBalancedPercent:
          resonanceBalancedPercent ?? this.resonanceBalancedPercent,
      resonanceAverageConfidence:
          resonanceAverageConfidence ?? this.resonanceAverageConfidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (trackingMode.present) {
      map['tracking_mode'] = Variable<String>(trackingMode.value);
    }
    if (targetHz.present) {
      map['target_hz'] = Variable<double>(targetHz.value);
    }
    if (targetVolumeDbfs.present) {
      map['target_volume_dbfs'] = Variable<double>(targetVolumeDbfs.value);
    }
    if (targetToleranceHz.present) {
      map['target_tolerance_hz'] = Variable<int>(targetToleranceHz.value);
    }
    if (targetVolumeToleranceDb.present) {
      map['target_volume_tolerance_db'] = Variable<int>(
        targetVolumeToleranceDb.value,
      );
    }
    if (targetSuggestionPreset.present) {
      map['target_suggestion_preset'] = Variable<String>(
        targetSuggestionPreset.value,
      );
    }
    if (averagePitchHz.present) {
      map['average_pitch_hz'] = Variable<double>(averagePitchHz.value);
    }
    if (minPitchHz.present) {
      map['min_pitch_hz'] = Variable<double>(minPitchHz.value);
    }
    if (maxPitchHz.present) {
      map['max_pitch_hz'] = Variable<double>(maxPitchHz.value);
    }
    if (timeAtTargetMs.present) {
      map['time_at_target_ms'] = Variable<int>(timeAtTargetMs.value);
    }
    if (totalTrackedTimeMs.present) {
      map['total_tracked_time_ms'] = Variable<int>(totalTrackedTimeMs.value);
    }
    if (audioFilePath.present) {
      map['audio_file_path'] = Variable<String>(audioFilePath.value);
    }
    if (chartPointsJson.present) {
      map['chart_points_json'] = Variable<String>(chartPointsJson.value);
    }
    if (practiceTextId.present) {
      map['practice_text_id'] = Variable<String>(practiceTextId.value);
    }
    if (resonanceState.present) {
      map['resonance_state'] = Variable<String>(resonanceState.value);
    }
    if (resonanceBalancedPercent.present) {
      map['resonance_balanced_percent'] = Variable<double>(
        resonanceBalancedPercent.value,
      );
    }
    if (resonanceAverageConfidence.present) {
      map['resonance_average_confidence'] = Variable<double>(
        resonanceAverageConfidence.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('mode: $mode, ')
          ..write('trackingMode: $trackingMode, ')
          ..write('targetHz: $targetHz, ')
          ..write('targetVolumeDbfs: $targetVolumeDbfs, ')
          ..write('targetToleranceHz: $targetToleranceHz, ')
          ..write('targetVolumeToleranceDb: $targetVolumeToleranceDb, ')
          ..write('targetSuggestionPreset: $targetSuggestionPreset, ')
          ..write('averagePitchHz: $averagePitchHz, ')
          ..write('minPitchHz: $minPitchHz, ')
          ..write('maxPitchHz: $maxPitchHz, ')
          ..write('timeAtTargetMs: $timeAtTargetMs, ')
          ..write('totalTrackedTimeMs: $totalTrackedTimeMs, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('chartPointsJson: $chartPointsJson, ')
          ..write('practiceTextId: $practiceTextId, ')
          ..write('resonanceState: $resonanceState, ')
          ..write('resonanceBalancedPercent: $resonanceBalancedPercent, ')
          ..write('resonanceAverageConfidence: $resonanceAverageConfidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VoiceTargetEntriesTable voiceTargetEntries =
      $VoiceTargetEntriesTable(this);
  late final $PracticeSessionEntriesTable practiceSessionEntries =
      $PracticeSessionEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    voiceTargetEntries,
    practiceSessionEntries,
  ];
}

typedef $$VoiceTargetEntriesTableCreateCompanionBuilder =
    VoiceTargetEntriesCompanion Function({
      required String id,
      required double targetHz,
      Value<double?> targetVolumeDbfs,
      required String suggestionPreset,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$VoiceTargetEntriesTableUpdateCompanionBuilder =
    VoiceTargetEntriesCompanion Function({
      Value<String> id,
      Value<double> targetHz,
      Value<double?> targetVolumeDbfs,
      Value<String> suggestionPreset,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

class $$VoiceTargetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VoiceTargetEntriesTable> {
  $$VoiceTargetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetHz => $composableBuilder(
    column: $table.targetHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestionPreset => $composableBuilder(
    column: $table.suggestionPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VoiceTargetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VoiceTargetEntriesTable> {
  $$VoiceTargetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetHz => $composableBuilder(
    column: $table.targetHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestionPreset => $composableBuilder(
    column: $table.suggestionPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VoiceTargetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoiceTargetEntriesTable> {
  $$VoiceTargetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get targetHz =>
      $composableBuilder(column: $table.targetHz, builder: (column) => column);

  GeneratedColumn<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestionPreset => $composableBuilder(
    column: $table.suggestionPreset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$VoiceTargetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoiceTargetEntriesTable,
          VoiceTargetEntry,
          $$VoiceTargetEntriesTableFilterComposer,
          $$VoiceTargetEntriesTableOrderingComposer,
          $$VoiceTargetEntriesTableAnnotationComposer,
          $$VoiceTargetEntriesTableCreateCompanionBuilder,
          $$VoiceTargetEntriesTableUpdateCompanionBuilder,
          (
            VoiceTargetEntry,
            BaseReferences<
              _$AppDatabase,
              $VoiceTargetEntriesTable,
              VoiceTargetEntry
            >,
          ),
          VoiceTargetEntry,
          PrefetchHooks Function()
        > {
  $$VoiceTargetEntriesTableTableManager(
    _$AppDatabase db,
    $VoiceTargetEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoiceTargetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoiceTargetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoiceTargetEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> targetHz = const Value.absent(),
                Value<double?> targetVolumeDbfs = const Value.absent(),
                Value<String> suggestionPreset = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoiceTargetEntriesCompanion(
                id: id,
                targetHz: targetHz,
                targetVolumeDbfs: targetVolumeDbfs,
                suggestionPreset: suggestionPreset,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double targetHz,
                Value<double?> targetVolumeDbfs = const Value.absent(),
                required String suggestionPreset,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoiceTargetEntriesCompanion.insert(
                id: id,
                targetHz: targetHz,
                targetVolumeDbfs: targetVolumeDbfs,
                suggestionPreset: suggestionPreset,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VoiceTargetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoiceTargetEntriesTable,
      VoiceTargetEntry,
      $$VoiceTargetEntriesTableFilterComposer,
      $$VoiceTargetEntriesTableOrderingComposer,
      $$VoiceTargetEntriesTableAnnotationComposer,
      $$VoiceTargetEntriesTableCreateCompanionBuilder,
      $$VoiceTargetEntriesTableUpdateCompanionBuilder,
      (
        VoiceTargetEntry,
        BaseReferences<
          _$AppDatabase,
          $VoiceTargetEntriesTable,
          VoiceTargetEntry
        >,
      ),
      VoiceTargetEntry,
      PrefetchHooks Function()
    >;
typedef $$PracticeSessionEntriesTableCreateCompanionBuilder =
    PracticeSessionEntriesCompanion Function({
      required String id,
      required int startedAt,
      required int endedAt,
      required int updatedAt,
      required String mode,
      required String trackingMode,
      required double targetHz,
      Value<double?> targetVolumeDbfs,
      required int targetToleranceHz,
      required int targetVolumeToleranceDb,
      required String targetSuggestionPreset,
      Value<double?> averagePitchHz,
      Value<double?> minPitchHz,
      Value<double?> maxPitchHz,
      required int timeAtTargetMs,
      required int totalTrackedTimeMs,
      Value<String?> audioFilePath,
      required String chartPointsJson,
      Value<String?> practiceTextId,
      Value<String?> resonanceState,
      Value<double?> resonanceBalancedPercent,
      Value<double?> resonanceAverageConfidence,
      Value<int> rowid,
    });
typedef $$PracticeSessionEntriesTableUpdateCompanionBuilder =
    PracticeSessionEntriesCompanion Function({
      Value<String> id,
      Value<int> startedAt,
      Value<int> endedAt,
      Value<int> updatedAt,
      Value<String> mode,
      Value<String> trackingMode,
      Value<double> targetHz,
      Value<double?> targetVolumeDbfs,
      Value<int> targetToleranceHz,
      Value<int> targetVolumeToleranceDb,
      Value<String> targetSuggestionPreset,
      Value<double?> averagePitchHz,
      Value<double?> minPitchHz,
      Value<double?> maxPitchHz,
      Value<int> timeAtTargetMs,
      Value<int> totalTrackedTimeMs,
      Value<String?> audioFilePath,
      Value<String> chartPointsJson,
      Value<String?> practiceTextId,
      Value<String?> resonanceState,
      Value<double?> resonanceBalancedPercent,
      Value<double?> resonanceAverageConfidence,
      Value<int> rowid,
    });

class $$PracticeSessionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionEntriesTable> {
  $$PracticeSessionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetHz => $composableBuilder(
    column: $table.targetHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetToleranceHz => $composableBuilder(
    column: $table.targetToleranceHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetVolumeToleranceDb => $composableBuilder(
    column: $table.targetVolumeToleranceDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetSuggestionPreset => $composableBuilder(
    column: $table.targetSuggestionPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averagePitchHz => $composableBuilder(
    column: $table.averagePitchHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minPitchHz => $composableBuilder(
    column: $table.minPitchHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxPitchHz => $composableBuilder(
    column: $table.maxPitchHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeAtTargetMs => $composableBuilder(
    column: $table.timeAtTargetMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTrackedTimeMs => $composableBuilder(
    column: $table.totalTrackedTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioFilePath => $composableBuilder(
    column: $table.audioFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chartPointsJson => $composableBuilder(
    column: $table.chartPointsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get practiceTextId => $composableBuilder(
    column: $table.practiceTextId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resonanceState => $composableBuilder(
    column: $table.resonanceState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get resonanceBalancedPercent => $composableBuilder(
    column: $table.resonanceBalancedPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get resonanceAverageConfidence => $composableBuilder(
    column: $table.resonanceAverageConfidence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeSessionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionEntriesTable> {
  $$PracticeSessionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetHz => $composableBuilder(
    column: $table.targetHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetToleranceHz => $composableBuilder(
    column: $table.targetToleranceHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetVolumeToleranceDb => $composableBuilder(
    column: $table.targetVolumeToleranceDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetSuggestionPreset => $composableBuilder(
    column: $table.targetSuggestionPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averagePitchHz => $composableBuilder(
    column: $table.averagePitchHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minPitchHz => $composableBuilder(
    column: $table.minPitchHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxPitchHz => $composableBuilder(
    column: $table.maxPitchHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeAtTargetMs => $composableBuilder(
    column: $table.timeAtTargetMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTrackedTimeMs => $composableBuilder(
    column: $table.totalTrackedTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioFilePath => $composableBuilder(
    column: $table.audioFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chartPointsJson => $composableBuilder(
    column: $table.chartPointsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get practiceTextId => $composableBuilder(
    column: $table.practiceTextId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resonanceState => $composableBuilder(
    column: $table.resonanceState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get resonanceBalancedPercent => $composableBuilder(
    column: $table.resonanceBalancedPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get resonanceAverageConfidence => $composableBuilder(
    column: $table.resonanceAverageConfidence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeSessionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionEntriesTable> {
  $$PracticeSessionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetHz =>
      $composableBuilder(column: $table.targetHz, builder: (column) => column);

  GeneratedColumn<double> get targetVolumeDbfs => $composableBuilder(
    column: $table.targetVolumeDbfs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetToleranceHz => $composableBuilder(
    column: $table.targetToleranceHz,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetVolumeToleranceDb => $composableBuilder(
    column: $table.targetVolumeToleranceDb,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetSuggestionPreset => $composableBuilder(
    column: $table.targetSuggestionPreset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averagePitchHz => $composableBuilder(
    column: $table.averagePitchHz,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minPitchHz => $composableBuilder(
    column: $table.minPitchHz,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxPitchHz => $composableBuilder(
    column: $table.maxPitchHz,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeAtTargetMs => $composableBuilder(
    column: $table.timeAtTargetMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTrackedTimeMs => $composableBuilder(
    column: $table.totalTrackedTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioFilePath => $composableBuilder(
    column: $table.audioFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chartPointsJson => $composableBuilder(
    column: $table.chartPointsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get practiceTextId => $composableBuilder(
    column: $table.practiceTextId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resonanceState => $composableBuilder(
    column: $table.resonanceState,
    builder: (column) => column,
  );

  GeneratedColumn<double> get resonanceBalancedPercent => $composableBuilder(
    column: $table.resonanceBalancedPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get resonanceAverageConfidence => $composableBuilder(
    column: $table.resonanceAverageConfidence,
    builder: (column) => column,
  );
}

class $$PracticeSessionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeSessionEntriesTable,
          PracticeSessionEntry,
          $$PracticeSessionEntriesTableFilterComposer,
          $$PracticeSessionEntriesTableOrderingComposer,
          $$PracticeSessionEntriesTableAnnotationComposer,
          $$PracticeSessionEntriesTableCreateCompanionBuilder,
          $$PracticeSessionEntriesTableUpdateCompanionBuilder,
          (
            PracticeSessionEntry,
            BaseReferences<
              _$AppDatabase,
              $PracticeSessionEntriesTable,
              PracticeSessionEntry
            >,
          ),
          PracticeSessionEntry,
          PrefetchHooks Function()
        > {
  $$PracticeSessionEntriesTableTableManager(
    _$AppDatabase db,
    $PracticeSessionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PracticeSessionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PracticeSessionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int> endedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> trackingMode = const Value.absent(),
                Value<double> targetHz = const Value.absent(),
                Value<double?> targetVolumeDbfs = const Value.absent(),
                Value<int> targetToleranceHz = const Value.absent(),
                Value<int> targetVolumeToleranceDb = const Value.absent(),
                Value<String> targetSuggestionPreset = const Value.absent(),
                Value<double?> averagePitchHz = const Value.absent(),
                Value<double?> minPitchHz = const Value.absent(),
                Value<double?> maxPitchHz = const Value.absent(),
                Value<int> timeAtTargetMs = const Value.absent(),
                Value<int> totalTrackedTimeMs = const Value.absent(),
                Value<String?> audioFilePath = const Value.absent(),
                Value<String> chartPointsJson = const Value.absent(),
                Value<String?> practiceTextId = const Value.absent(),
                Value<String?> resonanceState = const Value.absent(),
                Value<double?> resonanceBalancedPercent = const Value.absent(),
                Value<double?> resonanceAverageConfidence =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeSessionEntriesCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                updatedAt: updatedAt,
                mode: mode,
                trackingMode: trackingMode,
                targetHz: targetHz,
                targetVolumeDbfs: targetVolumeDbfs,
                targetToleranceHz: targetToleranceHz,
                targetVolumeToleranceDb: targetVolumeToleranceDb,
                targetSuggestionPreset: targetSuggestionPreset,
                averagePitchHz: averagePitchHz,
                minPitchHz: minPitchHz,
                maxPitchHz: maxPitchHz,
                timeAtTargetMs: timeAtTargetMs,
                totalTrackedTimeMs: totalTrackedTimeMs,
                audioFilePath: audioFilePath,
                chartPointsJson: chartPointsJson,
                practiceTextId: practiceTextId,
                resonanceState: resonanceState,
                resonanceBalancedPercent: resonanceBalancedPercent,
                resonanceAverageConfidence: resonanceAverageConfidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAt,
                required int endedAt,
                required int updatedAt,
                required String mode,
                required String trackingMode,
                required double targetHz,
                Value<double?> targetVolumeDbfs = const Value.absent(),
                required int targetToleranceHz,
                required int targetVolumeToleranceDb,
                required String targetSuggestionPreset,
                Value<double?> averagePitchHz = const Value.absent(),
                Value<double?> minPitchHz = const Value.absent(),
                Value<double?> maxPitchHz = const Value.absent(),
                required int timeAtTargetMs,
                required int totalTrackedTimeMs,
                Value<String?> audioFilePath = const Value.absent(),
                required String chartPointsJson,
                Value<String?> practiceTextId = const Value.absent(),
                Value<String?> resonanceState = const Value.absent(),
                Value<double?> resonanceBalancedPercent = const Value.absent(),
                Value<double?> resonanceAverageConfidence =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeSessionEntriesCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                updatedAt: updatedAt,
                mode: mode,
                trackingMode: trackingMode,
                targetHz: targetHz,
                targetVolumeDbfs: targetVolumeDbfs,
                targetToleranceHz: targetToleranceHz,
                targetVolumeToleranceDb: targetVolumeToleranceDb,
                targetSuggestionPreset: targetSuggestionPreset,
                averagePitchHz: averagePitchHz,
                minPitchHz: minPitchHz,
                maxPitchHz: maxPitchHz,
                timeAtTargetMs: timeAtTargetMs,
                totalTrackedTimeMs: totalTrackedTimeMs,
                audioFilePath: audioFilePath,
                chartPointsJson: chartPointsJson,
                practiceTextId: practiceTextId,
                resonanceState: resonanceState,
                resonanceBalancedPercent: resonanceBalancedPercent,
                resonanceAverageConfidence: resonanceAverageConfidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeSessionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeSessionEntriesTable,
      PracticeSessionEntry,
      $$PracticeSessionEntriesTableFilterComposer,
      $$PracticeSessionEntriesTableOrderingComposer,
      $$PracticeSessionEntriesTableAnnotationComposer,
      $$PracticeSessionEntriesTableCreateCompanionBuilder,
      $$PracticeSessionEntriesTableUpdateCompanionBuilder,
      (
        PracticeSessionEntry,
        BaseReferences<
          _$AppDatabase,
          $PracticeSessionEntriesTable,
          PracticeSessionEntry
        >,
      ),
      PracticeSessionEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VoiceTargetEntriesTableTableManager get voiceTargetEntries =>
      $$VoiceTargetEntriesTableTableManager(_db, _db.voiceTargetEntries);
  $$PracticeSessionEntriesTableTableManager get practiceSessionEntries =>
      $$PracticeSessionEntriesTableTableManager(
        _db,
        _db.practiceSessionEntries,
      );
}
