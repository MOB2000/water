import 'package:flutter/material.dart';
import 'package:water/model/Gender.dart';

class AppSettings {
  Gender gender;
  int age;
  int dailyGoal;

  AppSettings.empty()
      : this(
          gender: Gender.male,
          age: 0,
          dailyGoal: 0,
        );

  AppSettings({
    required this.gender,
    required this.age,
    required this.dailyGoal,
  });

  AppSettings copyWith({
    Gender? gender,
    int? age,
    int? dailyGoal,
    bool? notificationsEnabled,
    TimeOfDay? notificationsFromTime,
    TimeOfDay? notificationsToTime,
    int? notificationsInterval,
  }) {
    return AppSettings(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }
}
