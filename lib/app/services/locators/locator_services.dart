import 'package:dreamhome/app/services/api_service/token_refresh_service/token_refresh_service.dart';
import 'package:dreamhome/app/services/app_state_service/app_state_service.dart';
import 'package:dreamhome/app/services/cash_services/caesh_sservice.dart';
import 'package:dreamhome/app/services/connection_service/connection_service.dart';
import 'package:dreamhome/app/services/connection_service/refresh_service.dart';
import 'package:dreamhome/app/services/local_storage_service/global_details.dart';
import 'package:dreamhome/app/services/local_storage_service/local_storage_service.dart';
import 'package:dreamhome/app/services/navigation_services/navigator_services.dart';
import 'package:dreamhome/app/services/riverpod_service/river_pod_service.dart';
import 'package:dreamhome/app/services/screen_size_service/screen_size_service.dart';
import 'package:dreamhome/app/services/session_service/session_services.dart';
import 'package:dreamhome/app/services/snackbar_service/snackbar_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Lifecycle
  locator.registerSingleton<AppLifecycleService>(
    AppLifecycleService()..initialize(),
  );

  // Basic services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => RiverPodService());
  locator.registerLazySingleton(() => CustomCacheService());
  locator.registerLazySingleton(() => ConnectionService());
  locator.registerLazySingleton(() => RefreshService());

  // Auth/session services
  locator.registerLazySingleton(() => TokenRefreshService());
  locator.registerLazySingleton(() => SessionServices());

  // Screen service
  locator.registerSingleton(ScreenSizeService());

  // Initialize local storage BEFORE global details
  final localStorage = locator.get<LocalStorageService>();
  await localStorage.init();

  // Register global details
  locator.registerSingleton<GlobalDetails>(GlobalDetails.instance);

  // Initialize global details
  await locator.get<GlobalDetails>().init();
}

// Globals
NavigationService get navigationService => locator.get<NavigationService>();

SnackbarService get snackbarService => locator.get<SnackbarService>();

LocalStorageService get localStorageService =>
    locator.get<LocalStorageService>();

GlobalDetails get globalDetails => locator.get<GlobalDetails>();

ScreenSizeService get sizeService => locator.get<ScreenSizeService>();

ConnectionService get connectionService => locator.get<ConnectionService>();

RefreshService get refreshService => locator.get<RefreshService>();

CustomCacheService get cacheService => locator.get<CustomCacheService>();

AppLifecycleService get lifecycleService => locator.get<AppLifecycleService>();

SessionServices get sessionService => locator.get<SessionServices>();

RiverPodService get riverPodService => locator.get<RiverPodService>();

TokenRefreshService get tokenRefreshService =>
    locator.get<TokenRefreshService>();
