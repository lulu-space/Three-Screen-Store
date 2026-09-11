import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/details_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/city_picker_screen.dart';
import '../screens/success_screen.dart';

class AppRoutes {
  // Route names as constants
  static const String splash = '/';
  static const String home = '/home';
  static const String details = '/details';
  static const String checkout = '/checkout';
  static const String cityPicker = '/city-picker';
  static const String success = '/success';

  // Generate routes with the locale change callback
  static Map<String, WidgetBuilder> getRoutes(Function(Locale) onLocaleChange) {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => HomeScreen(onLocaleChange: onLocaleChange),
      details: (context) => const DetailsScreen(),
      checkout: (context) => const CheckoutScreen(),
      cityPicker: (context) => const CityPickerScreen(),
      success: (context) => const SuccessScreen(),
    };
  }
}
