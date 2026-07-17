/// Shared endpoints — each app extends this class in its own module
/// as it adds functionality. For the scaffold we just need auth +
/// the general-settings ping used by the tenant-select screen.
class ApiEndpoints {
  static const String login = '/admin/login';
  static const String profile = '/admin/profile';
  static const String logout = '/admin/logout';

  static const String generalSettings = '/general-settings';

  // Universal scanner surface (reuses existing admin endpoints)
  static String lookupTracking(String tracking) =>
      '/admin/sorting/lookup/$tracking';
  static const String hubs = '/admin/sorting/hubs';
  static String setStatus(int parcelId) => '/admin/parcels/$parcelId/status';
}
