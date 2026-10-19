/// API endpoint constants.
class ApiConstants {
  const ApiConstants._();

  static const baseUrl = 'https://api.smrod.app/v1';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/me';
  static const forgotPassword = '/auth/forgot-password';
  static const vehicle = '/vehicles/current';
  static const pair = '/vehicles/pair';
  static const location = '/vehicles/current/location';
  static const locationHistory = '/vehicles/current/location/history';
  static const commands = '/vehicles/current/commands';
  static const securityEvents = '/vehicles/current/security/events';
  static const notifications = '/notifications';
  static const emergencies = '/emergency/events';
  static const sos = '/emergency/sos';
  static const geofences = '/geofences';
}
