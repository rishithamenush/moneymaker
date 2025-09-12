import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/overview/overview_page.dart';
import '../pages/splash/splash_page.dart';
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
        return MaterialPageRoute(
          builder: (_) => const OverviewPage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case AppRoutes.expenses:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Expenses Page')),
          ),
          settings: settings,
        );
      case AppRoutes.budget:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Budget Page')),
          ),
          settings: settings,
        );
      case AppRoutes.offers:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Offers Page')),
          ),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Settings Page')),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }
}
