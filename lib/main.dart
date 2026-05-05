import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/confirm_photo_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/detail_view_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/settings_screen.dart';

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
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/capture':
            return MaterialPageRoute(
              builder: (context) => const CaptureScreen(),
            );
          case '/confirm':
            return MaterialPageRoute(
              builder: (context) => const ConfirmPhotoScreen(),
            );
          case '/processing':
            return MaterialPageRoute(
              builder: (context) => const ProcessingScreen(),
            );
          case '/result':
            return MaterialPageRoute(
              builder: (context) => const ResultScreen(),
            );
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
          case '/settings':
            return MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
    );
  }
}

// Application main navigation and routing configured above
