import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:water/model/Gender.dart';
import 'package:water/model/settings/app_settings.dart';

class AppSettingsManager {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<AppSettings> getSettings() async {
    final SharedPreferences prefs = await _prefs;
    final genderInt = prefs.getInt(_AppSettingsKeys.gender) ?? -1;
    final gender = genderInt >= 0 ? Gender.values[genderInt] : null;
    final age = prefs.getInt(_AppSettingsKeys.age) ?? 25;
    final dailyGoal = prefs.getInt(_AppSettingsKeys.dailyGoal) ?? 3500;

    return AppSettings(
      age: age,
      gender: gender ?? Gender.male,
      dailyGoal: dailyGoal,
    );
  }

  static Future<bool> saveSettings(
    Gender? gender,
    int? age,
    int? dailyGoal,
  ) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setInt(_AppSettingsKeys.gender, gender != null ? gender.index : -1);
    prefs.setInt(_AppSettingsKeys.age, age ?? 0);
    prefs.setInt(_AppSettingsKeys.dailyGoal, dailyGoal ?? 0);

    return true;
  }
}

class _AppSettingsKeys {
  static const gender = "gender";
  static const age = "age";
  static const dailyGoal = "dailyGoal";
}
