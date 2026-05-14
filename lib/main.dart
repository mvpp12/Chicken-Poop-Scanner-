import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/history_screen.dart';
import 'screens/detail_view_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/diseases_guide_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/app_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicken Health Scan',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
          case '/home':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/main':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/capture':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/confirm':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/processing':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/result':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/history':
            return MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            );
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) =>
                  DetailViewScreen(item: args?['item'], index: args?['index']),
            );
          case '/tips':
            return MaterialPageRoute(builder: (context) => const TipsScreen());
          case '/onboarding':
            return MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const AppShell());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            );
          case '/otp':
            return MaterialPageRoute(builder: (context) => const OtpScreen());
          case '/diseases':
            return MaterialPageRoute(
              builder: (context) => const DiseasesGuideScreen(),
            );
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            );
          default:
            return MaterialPageRoute(builder: (context) => const AppShell());
        }
      },
    );
  }
}

// Application main navigation and routing configured above
