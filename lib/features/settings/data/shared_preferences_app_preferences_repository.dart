import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../practice/domain/pitch_training_mode.dart';
import '../domain/app_preferences_repository.dart';
import '../domain/app_settings.dart';

class SharedPreferencesAppPreferencesRepository
    implements AppPreferencesRepository {
  SharedPreferencesAppPreferencesRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _localeKey = 'settings.locale';
  static const _themeModeKey = 'settings.theme_mode';
  static const _smoothingWindowKey = 'settings.smoothing_window_ms';
  static const _targetToleranceKey = 'settings.target_tolerance_hz';
  static const _targetVolumeToleranceKey =
      'settings.target_volume_tolerance_db';
  static const _lastPitchTrainingModeKey = 'settings.last_pitch_training_mode';
  static const _liveFeedbackKey = 'settings.live_feedback_recording';
  static const _updatedAtKey = 'settings.updated_at_ms';

  @override
  AppSettings load() {
    final themeMode = switch (_preferences.getString(_themeModeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return AppSettings(
      localeCode:
          _preferences.getString(_localeKey) ?? AppSettings.systemLocaleCode,
      themeMode: themeMode,
      smoothingWindowMs:
          _preferences.getInt(_smoothingWindowKey) ??
          AppSettings.defaults.smoothingWindowMs,
      targetToleranceHz:
          _preferences.getInt(_targetToleranceKey) ??
          AppSettings.defaults.targetToleranceHz,
      targetVolumeToleranceDb:
          _preferences.getInt(_targetVolumeToleranceKey) ??
          AppSettings.defaults.targetVolumeToleranceDb,
      lastPitchTrainingMode: PitchTrainingMode.fromStorage(
        _preferences.getString(_lastPitchTrainingModeKey) ??
            AppSettings.defaults.lastPitchTrainingMode.storageValue,
      ),
      showLiveFeedbackDuringRecording:
          _preferences.getBool(_liveFeedbackKey) ??
          AppSettings.defaults.showLiveFeedbackDuringRecording,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        _preferences.getInt(_updatedAtKey) ??
            AppSettings.defaults.updatedAt.millisecondsSinceEpoch,
      ),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _preferences.setString(_localeKey, settings.localeCode);
    await _preferences.setString(_themeModeKey, settings.themeMode.name);
    await _preferences.setInt(_smoothingWindowKey, settings.smoothingWindowMs);
    await _preferences.setInt(_targetToleranceKey, settings.targetToleranceHz);
    await _preferences.setInt(
      _targetVolumeToleranceKey,
      settings.targetVolumeToleranceDb,
    );
    await _preferences.setString(
      _lastPitchTrainingModeKey,
      settings.lastPitchTrainingMode.storageValue,
    );
    await _preferences.setBool(
      _liveFeedbackKey,
      settings.showLiveFeedbackDuringRecording,
    );
    await _preferences.setInt(
      _updatedAtKey,
      settings.updatedAt.millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> clear() async {
    await save(
      AppSettings.defaults.copyWith(updatedAt: DateTime.now().toUtc()),
    );
  }
}
