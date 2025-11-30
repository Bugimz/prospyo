import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/bindings/bindings.dart';
import 'package:prospy/repository/routes/all_routes.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
/// The root widget of the application.
///
/// This widget sets the system UI overlay style and initializes the
/// GetMaterialApp widget with the necessary routes, theme, and initial binding.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style.
    // This includes setting the status bar color, brightness, and icon brightness.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // رنگ نوار وضعیت
        statusBarBrightness: Brightness.dark, // روشنایی نوار وضعیت
        statusBarIconBrightness:
            Brightness.dark, // روشنایی آیکون‌های نوار وضعیت
        systemNavigationBarColor: AppColor.mainWhiteColor, // رنگ نوار ناوبری
        systemNavigationBarDividerColor:
            AppColor.mainWhiteColor, // رنگ جداکننده نوار ناوبری
        systemNavigationBarIconBrightness:
            Brightness.dark, // روشنایی آیکون‌های نوار ناوبری
      ),
    );

    // Initialize the GetMaterialApp widget.
    return GetMaterialApp(
      // Define the routes for the app.
      getPages: AppRoutes.appRoutes(),

      // Set the initial binding.
      initialBinding: AllControllersBinding(),

      // Hide the debug banner.
      debugShowCheckedModeBanner: false,

      // Set the default locale and fallback locale.
      locale: const Locale('fa', 'IR'),
      fallbackLocale: const Locale('fa', 'IR'),

      // Set the title of the app.
      title: 'Flutter Demo',

      // Set the theme of the app.
      theme: ThemeData(
        // Define the color scheme of the app.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Use Material 3 design.
        useMaterial3: true,
      ),

      // Remove home and rely solely on initialRoute.
      initialRoute: '/splash',
    );
  }
}

/// The entry point of the application.
///
/// This function runs the [MyApp] widget as the root widget of the application.
void main() {
  // مقداردهی اولیه GetX
  WidgetsFlutterBinding.ensureInitialized();
  
  // Run the application
  runApp(const MyApp());
}
