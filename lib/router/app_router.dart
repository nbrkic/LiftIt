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
import '../features/splits/presentation/split_detail_screen.dart';
import '../features/splits/presentation/split_day_detail_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/stats/presentation/stats_screen.dart';

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
          routes: [
            GoRoute(
              path: '/splits',
              builder: (c, s) => const SplitsListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (c, s) => SplitDetailScreen(
                    splitId: int.parse(s.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'day/:dayId',
                      builder: (c, s) => SplitDayDetailScreen(
                        splitDayId: int.parse(s.pathParameters['dayId']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (c, s) => const ProfileScreen(),
              routes: [
                GoRoute(path: 'stats', builder: (c, s) => const StatsScreen()),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/active-workout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => ActiveWorkoutScreen(startFromSplitDayId: s.extra as int?),
    ),
  ],
);
