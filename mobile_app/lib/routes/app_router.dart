import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_paths.dart';
import '../features/appointment/presentation/views/appointment_detail_screen.dart';
import '../features/appointment/presentation/views/appointment_list_screen.dart';
import '../features/appointment/presentation/views/appointment_route_scope.dart';
import '../features/appointment/presentation/views/slot_selection_screen.dart';
import '../features/auth/presentation/views/auth_route_scope.dart';
import '../features/auth/presentation/views/forgot_password_screen.dart';
import '../features/auth/presentation/views/login_screen.dart';
import '../features/auth/presentation/views/register_screen.dart';
import '../features/auth/presentation/views/splash_view.dart';
import '../features/consultant/presentation/views/booking_confirm_screen.dart';
import '../features/consultant/presentation/views/consultant_detail_screen.dart';
import '../features/consultant/presentation/views/consultant_list_screen.dart';
import '../features/consultant/presentation/views/consultant_route_scope.dart';
import '../features/blog/presentation/views/blog_detail_screen.dart';
import '../features/blog/presentation/views/blog_list_screen.dart';
import '../features/blog/presentation/views/blog_route_scope.dart';
import '../features/profile/presentation/views/change_password_screen.dart';
import '../features/profile/presentation/views/profile_route_scope.dart';
import '../features/profile/presentation/views/profile_screen.dart';
import '../features/home/presentation/views/home_tab_view.dart';
import '../features/service/presentation/views/book_service_screen.dart';
import '../features/service/presentation/views/service_detail_screen.dart';
import '../features/service/presentation/views/service_list_screen.dart';
import '../features/service/presentation/views/service_route_scope.dart';
import '../features/service/presentation/views/test_record_detail_screen.dart';
import '../features/shell/presentation/views/app_shell_view.dart';
import 'auth_guard.dart';
import 'placeholder_page.dart';
import 'route_names.dart';

/// Application router with auth guards and shell navigation.
class AppRouter {
  AppRouter({
    required AuthStateReader authStateReader,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : _authGuard = AuthGuard(authStateReader: authStateReader) {
    router = GoRouter(
      navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      refreshListenable: authStateReader.listenable,
      redirect: _authGuard.redirect,
      routes: _routes,
      errorBuilder: (context, state) => PlaceholderPage(
        title: 'Không tìm thấy trang',
        subtitle: state.uri.path,
        icon: Icons.search_off_rounded,
      ),
    );
  }

  final AuthGuard _authGuard;
  late final GoRouter router;

  static final List<RouteBase> _routes = [
    GoRoute(
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) {
        final message = state.uri.queryParameters['message'];
        return AuthRouteScope(
          child: LoginScreen(initialMessage: message),
        );
      },
    ),
    GoRoute(
      path: RoutePaths.register,
      name: RouteNames.register,
      builder: (context, state) => const AuthRouteScope(
        child: RegisterScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      name: RouteNames.forgotPassword,
      builder: (context, state) => const AuthRouteScope(
        child: ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: RoutePaths.bookingConfirm,
      name: RouteNames.bookingConfirm,
      builder: (context, state) => BookingConfirmScreen(
        appointmentId: state.uri.queryParameters['appointmentId'],
        recordId: state.uri.queryParameters['recordId'],
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellView(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeTabView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.consultants,
              name: RouteNames.consultants,
              builder: (context, state) => const ConsultantRouteScope(
                child: ConsultantListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  name: RouteNames.consultantDetail,
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã tư vấn viên không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    return ConsultantRouteScope(
                      child: ConsultantDetailScreen(consultantId: id),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'book',
                      name: RouteNames.consultantSlotSelection,
                      builder: (context, state) {
                        final id =
                            int.tryParse(state.pathParameters['id'] ?? '');
                        if (id == null) {
                          return const PlaceholderPage(
                            title: 'Không hợp lệ',
                            subtitle: 'Mã tư vấn viên không hợp lệ.',
                            icon: Icons.error_outline_rounded,
                          );
                        }
                        return AppointmentRouteScope(
                          child: SlotSelectionScreen(consultantId: id),
                        );
                      },
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
              path: RoutePaths.medicalTests,
              name: RouteNames.medicalTests,
              builder: (context, state) => const ServiceRouteScope(
                child: ServiceListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'records/:recordId',
                  name: RouteNames.medicalTestRecordDetail,
                  builder: (context, state) {
                    final recordId = int.tryParse(
                      state.pathParameters['recordId'] ?? '',
                    );
                    if (recordId == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã hồ sơ không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    final booked =
                        state.uri.queryParameters['booked'] == '1';
                    return ServiceRouteScope(
                      child: TestRecordDetailScreen(
                        recordId: recordId,
                        showBookedMessage: booked,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: ':id',
                  name: RouteNames.medicalTestDetail,
                  builder: (context, state) {
                    final id =
                        int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã dịch vụ không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    return ServiceRouteScope(
                      child: ServiceDetailScreen(serviceId: id),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'book',
                      name: RouteNames.medicalTestBooking,
                      builder: (context, state) {
                        final id = int.tryParse(
                          state.pathParameters['id'] ?? '',
                        );
                        if (id == null) {
                          return const PlaceholderPage(
                            title: 'Không hợp lệ',
                            subtitle: 'Mã dịch vụ không hợp lệ.',
                            icon: Icons.error_outline_rounded,
                          );
                        }
                        return ServiceRouteScope(
                          child: BookServiceScreen(serviceId: id),
                        );
                      },
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
              path: RoutePaths.appointments,
              name: RouteNames.appointments,
              builder: (context, state) => const AppointmentRouteScope(
                child: AppointmentListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'test-records/:recordId',
                  name: RouteNames.appointmentTestRecordDetail,
                  builder: (context, state) {
                    final recordId = int.tryParse(
                      state.pathParameters['recordId'] ?? '',
                    );
                    if (recordId == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã hồ sơ không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    final booked =
                        state.uri.queryParameters['booked'] == '1';
                    return AppointmentRouteScope(
                      child: TestRecordDetailScreen(
                        recordId: recordId,
                        showBookedMessage: booked,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: ':id',
                  name: RouteNames.appointmentDetail,
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã lịch hẹn không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    return AppointmentRouteScope(
                      child: AppointmentDetailScreen(appointmentId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.blogs,
              name: RouteNames.blogs,
              builder: (context, state) => const BlogRouteScope(
                child: BlogListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  name: RouteNames.blogDetail,
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) {
                      return const PlaceholderPage(
                        title: 'Không hợp lệ',
                        subtitle: 'Mã bài viết không hợp lệ.',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                    return BlogRouteScope(
                      child: BlogDetailScreen(blogId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) => const ProfileRouteScope(
                child: ProfileScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'change-password',
                  name: RouteNames.changePassword,
                  builder: (context, state) => const ProfileRouteScope(
                    child: ChangePasswordScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
