import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_constants.dart';
import 'theme/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

/// Root widget of the Darzi App.
///
/// Uses GetMaterialApp for GetX state management and navigation.
/// Theme is kept from the template's clean design system.
class DarziApp extends StatelessWidget {
  const DarziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Always light — simple for workers
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // GetX snackbar default duration
      defaultTransition: Transition.fade,
    );
  }
}
