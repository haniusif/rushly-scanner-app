import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/providers.dart';
import '../../../core/config/env.dart';
import '../../../shared/l10n/app_localizations.dart';

class TenantSelectScreen extends ConsumerStatefulWidget {
  const TenantSelectScreen({super.key});
  @override
  ConsumerState<TenantSelectScreen> createState() =>
      _TenantSelectScreenState();
}

class _TenantSelectScreenState
    extends ConsumerState<TenantSelectScreen> {
  final _key = GlobalKey<FormState>();
  final _workspace = TextEditingController();
  final _advancedUrl = TextEditingController();
  bool _advanced = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _workspace.dispose();
    _advancedUrl.dispose();
    super.dispose();
  }

  String _buildBaseUrl() {
    if (_advanced) {
      var v = _advancedUrl.text.trim();
      if (v.endsWith('/')) v = v.substring(0, v.length - 1);
      if (!v.contains('/api/')) v = '$v/api/v10';
      return v;
    }
    final slug = _workspace.text.trim().toLowerCase();
    return 'https://$slug.${Env.tenantHostSuffix}/api/v10';
  }

  Future<void> _connect() async {
    if (_busy) return;
    if (!(_key.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final url = _buildBaseUrl();
    final label = _advanced
        ? Uri.tryParse(url)?.host ?? url
        : _workspace.text.trim();
    try {
      final dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {'Accept': 'application/json', 'apiKey': Env.apiKey},
      ));
      final res = await dio.get<dynamic>('/general-settings');
      if (res.statusCode == null || res.statusCode! >= 400) {
        throw Exception('HTTP ${res.statusCode}');
      }
      await ref.read(tenantStorageProvider).write(
          baseUrl: url, label: label);
      ref.invalidate(tenantBaseUrlProvider);
      if (!mounted) return;
      GoRouter.of(context).go('/login');
    } catch (e) {
      final msg = e is DioException
          ? (e.response?.statusCode != null
              ? 'HTTP ${e.response!.statusCode}'
              : e.message ?? 'Connection failed')
          : e.toString();
      setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final preview = _buildBaseUrl();
    return Scaffold(
      appBar: AppBar(title: Text(s.chooseWorkspace)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              const Icon(Icons.qr_code_scanner, size: 64),
              const SizedBox(height: 16),
              Text(
                s.chooseWorkspaceHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (!_advanced) ...[
                TextFormField(
                  controller: _workspace,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: s.workspaceName,
                    hintText: 'acme',
                    border: const OutlineInputBorder(),
                    suffixText: '.${Env.tenantHostSuffix}',
                  ),
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _connect(),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return s.required;
                    if (!RegExp(r'^[a-z0-9][a-z0-9-]*$').hasMatch(t)) {
                      return s.workspaceNameInvalid;
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _advancedUrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: s.apiUrl,
                    hintText: 'https://your-server.com/api/v10',
                    border: const OutlineInputBorder(),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => _connect(),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return s.required;
                    final u = Uri.tryParse(t);
                    if (u == null || !u.hasScheme) return s.invalidUrl;
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 8),
              Text('→ $preview',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _advanced = !_advanced),
                  child: Text(_advanced ? s.simpleMode : s.advancedMode),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _connect,
                child: _busy
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(s.connect),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
