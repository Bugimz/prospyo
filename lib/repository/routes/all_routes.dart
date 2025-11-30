import 'package:get/get.dart';
import 'package:prospy/repository/routes/routes_name.dart';
import 'package:prospy/views/screens/category_screen.dart';
import 'package:prospy/views/screens/extensions_screen.dart';
import 'package:prospy/views/screens/game_screen.dart';
import 'package:prospy/views/screens/gameinstructions_screen.dart';
import 'package:prospy/views/screens/home_screen.dart';
import 'package:prospy/views/screens/splash_screen.dart';
import 'package:prospy/views/screens/stats_screen.dart';
import 'package:prospy/views/screens/time_selection_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splash,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: RouteName.home,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: RouteName.gameScreen,
          page: () => GameScreen(),
        ),
        GetPage(
          name: RouteName.categoryScreen,
          page: () => CategorySelectionScreen(),
        ),
        GetPage(
          name: RouteName.extensionScreen,
          page: () => const ExtensionsScreen(),
        ),
        GetPage(
          name: RouteName.timeScreen,
          page: () => const TimeSelectionScreen(),
        ),
        GetPage(
          name: RouteName.tutorialScreen,
          page: () => const GameInstructionsScreen(),
        ),
        GetPage(
          name: RouteName.statsScreen,
          page: () => StatsScreen(),
        ),
      ];
}
