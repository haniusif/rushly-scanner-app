import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/providers.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/home_shell.dart';
import '../../features/tenant/presentation/tenant_select_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc == '/splash') return null;

      final tenantConfigured =
          ref.read(tenantBaseUrlProvider).valueOrNull?.isNotEmpty ??
              false;
      if (!tenantConfigured && loc != '/tenant') return '/tenant';
      if (tenantConfigured && loc == '/tenant') return '/login';

      final isAuthed =
          ref.read(authControllerProvider).isAuthenticated;
      final isPublicRoute = loc == '/login' || loc == '/tenant';
      if (!isAuthed && !isPublicRoute) return '/login';
      if (isAuthed && loc == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const _Splash()),
      GoRoute(path: '/tenant', builder: (_, __) => const TenantSelectScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeShell()),
    ],
  );
});

class _Splash extends ConsumerStatefulWidget {
  const _Splash();
  @override
  ConsumerState<_Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<_Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final baseUrl = await ref.read(tenantBaseUrlProvider.future);
      if (!mounted) return;
      if (baseUrl == null || baseUrl.isEmpty) {
        GoRouter.of(context).go('/tenant');
        return;
      }
      final ok = await ref.read(authControllerProvider.notifier).restore();
      if (!mounted) return;
      GoRouter.of(context).go(ok ? '/home' : '/login');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
