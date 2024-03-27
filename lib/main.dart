import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorage;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'data/user/auth_repository_impl.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/connection/connection_cubit.dart';
import 'logic/settings/settings_cubit.dart';
import 'logic/settings/settings_data.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectionCubit(
            connectivity: Connectivity(),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AuthCubit(
            authRepository: AuthRepositoryImpl(),
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.darkDuringDayInAutoMode !=
                current.darkDuringDayInAutoMode ||
            previous.appLanguague != current.appLanguague ||
            previous.themeSystem != current.themeSystem,
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => context.loc.appName,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: AppRouter.router,
            theme: ThemeData(
              useMaterial3: state.themeSystem == AppThemeSystem.material3,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: state.themeSystem == AppThemeSystem.material3,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: state.themeMode.toMaterialThemeMode(
              darkDuringDayInAutoMode: state.darkDuringDayInAutoMode,
            ),
            locale: state.appLanguague == AppLanguague.system
                ? null
                : Locale(state.appLanguague.name),
          );
        },
      ),
    );
  }
}
