/// Application-wide constants.
class AppConstants {
  const AppConstants._();

  static const appName = 'VSCU-100';
  static const tagline = 'Edge intelligence for connected vehicle safety.';

  /// Pilot builds talk to the local store until the NestJS gateway is live.
  static const usePilotData = false;

  static const tokenKey = 'access_token';
  static const emailKey = 'session_email';
  static const biometricKey = 'biometric_lock';
  static const voiceKey = 'robotic_voice';
  static const pilotSnapshotKey = 'pilot_snapshot';

  static const demoEmail = 'owner@smrod.app';
  static const demoPassword = 'Smrod1234';
  static const emergencyContact = '+251 911 000 112';

  static const homeLatitude = 9.0300;
  static const homeLongitude = 38.7400;
}

enum AlertSeverity { info, warning, critical }

enum RiskLevel { low, medium, critical }

extension RiskLevelLabel on RiskLevel {
  String get label => switch (this) {
    RiskLevel.low => 'Low',
    RiskLevel.medium => 'Medium',
    RiskLevel.critical => 'Critical',
  };
}
