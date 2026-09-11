import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shell/app_shell.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/history/presentation/session_detail_screen.dart';
import '../features/exercises/presentation/exercise_library_screen.dart';
import '../features/exercises/presentation/exercise_detail_screen.dart';
import '../features/workout/presentation/active_workout_screen.dart';
import '../features/splits/presentation/splits_list_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/stats/presentation/stats_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/bodyweight/presentation/bodyweight_screen.dart';
import '../features/streaks/presentation/streak_levels_screen.dart';
import '../features/nutrition/presentation/nutrition_diary_screen.dart';
import '../features/nutrition/presentation/food_search_screen.dart';
import '../features/nutrition/presentation/barcode_scan_screen.dart';
import '../features/nutrition/presentation/photo_results_screen.dart';
import '../features/nutrition/presentation/saved_foods_screen.dart';
import '../features/nutrition/presentation/supplements_screen.dart';
import '../features/nutrition/presentation/nutrition_trends_screen.dart';
import '../features/nutrition/services/food_search_result.dart';
import '../features/bmi_calculator/presentation/bmi_calculator_screen.dart';
import '../features/progress_photos/presentation/progress_photos_screen.dart';
import '../features/progress_photos/presentation/progress_photo_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (c, s) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (c, s) => const HistoryScreen(),
              routes: [
                GoRoute(
                  path: 'session/:id',
                  builder: (c, s) => SessionDetailScreen(
                    sessionId: int.parse(s.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exercises',
              builder: (c, s) => const ExerciseLibraryScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (c, s) => ExerciseDetailScreen(
                    exerciseId: int.parse(s.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/stats', builder: (c, s) => const StatsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen())],
        ),
      ],
    ),
    GoRoute(
      path: '/active-workout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => ActiveWorkoutScreen(startFromSplitDayId: s.extra as int?),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/bodyweight',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const BodyweightScreen(),
    ),
    GoRoute(
      path: '/splits',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const SplitsListScreen(),
    ),
    GoRoute(
      path: '/streaks',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const StreakLevelsScreen(),
    ),
    GoRoute(
      path: '/nutrition',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const NutritionDiaryScreen(),
      routes: [
        GoRoute(path: 'search', builder: (c, s) => FoodSearchScreen(day: s.extra as DateTime)),
        GoRoute(path: 'scan', builder: (c, s) => BarcodeScanScreen(day: s.extra as DateTime)),
        GoRoute(path: 'saved', builder: (c, s) => SavedFoodsScreen(day: s.extra as DateTime)),
        GoRoute(path: 'supplements', builder: (c, s) => const SupplementsScreen()),
        GoRoute(path: 'trends', builder: (c, s) => const NutritionTrendsScreen()),
        GoRoute(
          path: 'photo-results',
          builder: (c, s) {
            final extra = s.extra as ({List<GeminiFoodItem> items, DateTime day});
            return PhotoResultsScreen(items: extra.items, day: extra.day);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/bmi-calculator',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const BmiCalculatorScreen(),
    ),
    GoRoute(
      path: '/progress-photos',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const ProgressPhotosScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (c, s) => ProgressPhotoDetailScreen(photoId: int.parse(s.pathParameters['id']!)),
        ),
      ],
    ),
  ],
);
