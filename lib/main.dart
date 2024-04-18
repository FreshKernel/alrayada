import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity;
import 'package:dynamic_color/dynamic_color.dart' show DynamicColorBuilder;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorage;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'data/live_chat/admin/admin_live_chat_repository_impl.dart';
import 'data/live_chat/live_chat_repository_impl.dart';
import 'data/user/admin/admin_user_repository_impl.dart';
import 'data/user/user_repository_impl.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'logic/connectivity/connectivity_cubit.dart';
import 'logic/live_chat/admin/admin_live_chat_cubit.dart';
import 'logic/live_chat/live_chat_cubit.dart';
import 'logic/settings/settings_cubit.dart';
import 'logic/settings/settings_data.dart';
import 'logic/user/admin/admin_user_cubit.dart';
import 'logic/user/user_cubit.dart';
import 'screens/app_router.dart';
import 'utils/app_logger.dart';
import 'utils/env.dart';
import 'utils/server.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory(),
    );
    await dotenv.load(fileName: '.env');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    if (kDebugMode && getEnvironmentVariables().useDevServer) {
      ServerConfigurations.baseUrl =
          await ServerConfigurations.getDevelopmentBaseUrl();
    }

    runApp(const MyApp());
  } catch (e) {
    AppLogger.error(
      e.toString(),
      error: e,
    );
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return Text(context.loc.unknownErrorWithMsg(e.toString()));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialApp _getMaterialApp({
    required SettingsState state,
    required ColorScheme lightColorScheme,
    required ColorScheme darkColorScheme,
  }) =>
      MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => context.loc.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: state.themeSystem == AppThemeSystem.material3,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: state.themeSystem == AppThemeSystem.material3,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: darkColorScheme,
        ),
        themeMode: state.themeMode.toMaterialThemeMode(
          darkDuringDayInAutoMode: state.darkDuringDayInAutoMode,
        ),
        locale: state.appLanguague == AppLanguague.system
            ? null
            : Locale(state.appLanguague.name),
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectivityCubit(
            connectivity: Connectivity(),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => UserCubit(
            userRepository: UserRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => AdminUserCubit(
            adminUserRepository: AdminUserRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => LiveChatCubit(
            liveChatRepository: LiveChatRepositoryImpl(),
            userCubit: context.read<UserCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => AdminLiveChatCubit(
            adminLiveChatRepository: AdminLiveChatRepositoryImpl(),
          ),
        )
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.darkDuringDayInAutoMode !=
                current.darkDuringDayInAutoMode ||
            previous.appLanguague != current.appLanguague ||
            previous.themeSystem != current.themeSystem ||
            previous.useDynamicColors != current.useDynamicColors,
        builder: (context, state) {
          // Default color schemes will be used if user don't want dynamic colors
          // or if we can't get the dynamic colors for some reason
          final lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          );
          final darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          );
          if (!state.useDynamicColors) {
            return _getMaterialApp(
              state: state,
              lightColorScheme: lightColorScheme,
              darkColorScheme: darkColorScheme,
            );
          }
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return _getMaterialApp(
                state: state,
                lightColorScheme: lightDynamic ?? lightColorScheme,
                darkColorScheme: darkDynamic ?? darkColorScheme,
              );
            },
          );
        },
      ),
    );
  }
}
