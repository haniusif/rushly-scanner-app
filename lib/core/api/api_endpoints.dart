/// Shared endpoints — each app extends this class in its own module
/// as it adds functionality. For the scaffold we just need auth +
/// the general-settings ping used by the tenant-select screen.
class ApiEndpoints {
  static const String login = '/admin/login';
  static const String profile = '/admin/profile';
  static const String logout = '/admin/logout';

  static const String generalSettings = '/general-settings';
}
