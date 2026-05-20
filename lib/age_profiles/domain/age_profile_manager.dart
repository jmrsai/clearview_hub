import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AgeGroup { kids, teens, adults, seniors }

class AgeProfileConfig {
  final AgeGroup group;
  final String title;
  final bool gamifyEverything;
  final bool strictTimeLimits;
  final double uiScaleFactor;
  final bool simplifyNavigation;
  final bool enableAnalytics;

  const AgeProfileConfig({
    required this.group,
    required this.title,
    required this.gamifyEverything,
    required this.strictTimeLimits,
    required this.uiScaleFactor,
    required this.simplifyNavigation,
    required this.enableAnalytics,
  });

  static const kids = AgeProfileConfig(
    group: AgeGroup.kids,
    title: 'Kids (5-12)',
    gamifyEverything: true,
    strictTimeLimits: true,
    uiScaleFactor: 1.2,
    simplifyNavigation: true,
    enableAnalytics: false,
  );

  static const teens = AgeProfileConfig(
    group: AgeGroup.teens,
    title: 'Teens (13-19)',
    gamifyEverything: true,
    strictTimeLimits: false,
    uiScaleFactor: 1.0,
    simplifyNavigation: false,
    enableAnalytics: true,
  );

  static const adults = AgeProfileConfig(
    group: AgeGroup.adults,
    title: 'Adults (20-50)',
    gamifyEverything: false,
    strictTimeLimits: false,
    uiScaleFactor: 1.0,
    simplifyNavigation: false,
    enableAnalytics: true,
  );

  static const seniors = AgeProfileConfig(
    group: AgeGroup.seniors,
    title: 'Seniors (50+)',
    gamifyEverything: false,
    strictTimeLimits: false,
    uiScaleFactor: 1.3,
    simplifyNavigation: true,
    enableAnalytics: false,
  );
}

class AgeProfileManager extends ChangeNotifier {
  static final AgeProfileManager _instance = AgeProfileManager._internal();
  factory AgeProfileManager() => _instance;
  AgeProfileManager._internal();

  AgeProfileConfig _currentConfig = AgeProfileConfig.adults;
  
  AgeProfileConfig get currentConfig => _currentConfig;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGroupIndex = prefs.getInt('age_group_index');
    if (savedGroupIndex != null && savedGroupIndex < AgeGroup.values.length) {
      _setProfileConfig(AgeGroup.values[savedGroupIndex]);
    }
  }

  void _setProfileConfig(AgeGroup group) {
    switch (group) {
      case AgeGroup.kids:
        _currentConfig = AgeProfileConfig.kids;
        break;
      case AgeGroup.teens:
        _currentConfig = AgeProfileConfig.teens;
        break;
      case AgeGroup.adults:
        _currentConfig = AgeProfileConfig.adults;
        break;
      case AgeGroup.seniors:
        _currentConfig = AgeProfileConfig.seniors;
        break;
    }
  }

  Future<void> setAgeGroup(AgeGroup group) async {
    _setProfileConfig(group);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age_group_index', group.index);
  }
}
