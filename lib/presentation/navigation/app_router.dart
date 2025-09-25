import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/overview/overview_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/add/add_transaction_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../../app/routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case AppRoutes.overview:
        return _fadeRoute(const OverviewPage(), settings);
      case AppRoutes.home:
        return _fadeRoute(const HomePage(), settings);
      case AppRoutes.expenses:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Expenses Page')),
          ),
          settings: settings,
        );
      case AppRoutes.addExpense:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Add Expense Page')),
          ),
          settings: settings,
        );
      case AppRoutes.addTransaction:
        return MaterialPageRoute(
          builder: (_) => const AddTransactionPage(),
          settings: settings,
        );
      case AppRoutes.budget:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Budget Page')),
          ),
          settings: settings,
        );
      case AppRoutes.settings:
        return _fadeRoute(const SettingsPage(), settings);
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }

  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 180),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final slide = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
