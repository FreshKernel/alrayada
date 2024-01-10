import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/user/auth_repository_impl.dart';
import 'l10n/app_localizations.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/connection/connection_cubit.dart';
import 'logic/settings/settings_cubit.dart';
import 'screens/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory(),
    );
    await dotenv.load(fileName: '.env');
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: Text(e.toString()),
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
          create: (context) => AuthCubit(
            authRepository: AuthRepositoryImpl(),
          ),
        ),
      ],
      child: PlatformProvider(
        initialPlatform: TargetPlatform.iOS,
        builder: (context) => BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (context, state) {
            return PlatformTheme(
              builder: (context) => PlatformApp.router(
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (context) => context.loc.appName,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: AppRouter.router,
                material: (context, platform) => MaterialAppRouterData(
                  theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  themeMode: state.themeMode,
                ),
                cupertino: (context, platform) => CupertinoAppRouterData(
                  theme: state.themeMode == ThemeMode.system
                      ? const CupertinoThemeData()
                      : CupertinoThemeData(
                          brightness: state.themeMode == ThemeMode.dark
                              ? Brightness.dark
                              : Brightness.light,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
