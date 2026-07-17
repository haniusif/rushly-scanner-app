import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl =>
      dotenv.maybeGet('API_BASE_URL') ??
          'https://api.rushly-logistic.com/api/v10';
  static String get apiKey =>
      dotenv.maybeGet('API_KEY') ?? '123456rx-ecourier123456';

  /// Host suffix used by the tenant-select "workspace name" mode.
  /// A user typing "acme" yields `https://acme.<hostSuffix>/api/v10`.
  static String get tenantHostSuffix {
    final v = dotenv.maybeGet('TENANT_HOST_SUFFIX');
    if (v != null && v.isNotEmpty) return v;
    return 'rushly-logistic.com';
  }

  static Future<void> load() => dotenv.load(fileName: '.env');
}
