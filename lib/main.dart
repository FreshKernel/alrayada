import 'package:connectivity_plus/connectivity_plus.dart' show Connectivity;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorage;
import 'package:image_picker_android/image_picker_android.dart'
    show ImagePickerAndroid;
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart'
    show ImagePickerPlatform;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'admin/live_chat/data/remote_admin_live_chat_api.dart';
import 'admin/live_chat/logic/admin_live_chat_cubit.dart';
import 'admin/user/data/remote_admin_user_api.dart';
import 'admin/user/logic/admin_user_cubit.dart';
import 'auth/data/remote_user_api.dart';
import 'auth/logic/user_cubit.dart';
import 'common/app_logger.dart';
import 'common/environment_variables.dart';
import 'common/localizations/app_localization_extension.dart';
import 'common/logic/connectivity/connectivity_cubit.dart';
import 'common/presentation/app_router.dart';
import 'common/presentation/widgets/my_dynamic_color_builder.dart';
import 'common/server.dart';
import 'firebase_options.dart';
import 'live_chat/data/remote_live_chat_api.dart';
import 'live_chat/logic/live_chat_cubit.dart';
import 'products/data/category/remote_product_category_api.dart';
import 'products/logic/category/product_category_cubit.dart';
import 'settings/data/settings_data.dart';
import 'settings/logic/settings_cubit.dart';

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

    final ImagePickerPlatform imagePickerImplementation =
        ImagePickerPlatform.instance;
    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
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
          lazy: false,
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
            userApi: RemoteUserApi(),
          ),
        ),
        BlocProvider(
          create: (context) => AdminUserCubit(
            adminUserApi: RemoteAdminUserApi(),
          ),
        ),
        BlocProvider(
          create: (context) => LiveChatCubit(
            liveChatApi: RemoteLiveChatApi(),
          ),
        ),
        BlocProvider(
          create: (context) => AdminLiveChatCubit(
            adminLiveChatApi: RemoteAdminLiveChatApi(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductCategoryCubit(
            productCategoryApi: RemoteProductCategoryApi(),
          ),
        ),
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
          return MyDynamicColorBuilder(
            isEnabled: state.useDynamicColors,
            builder: (lightDynamic, darkDynamic) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => context.loc.appName,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: AppRouter.router,
              theme: ThemeData(
                useMaterial3: state.themeSystem == AppThemeSystem.material3,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                colorScheme: lightDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: Colors.green,
                      brightness: Brightness.light,
                    ),
              ),
              darkTheme: ThemeData(
                useMaterial3: state.themeSystem == AppThemeSystem.material3,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                colorScheme: darkDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: Colors.green,
                      brightness: Brightness.dark,
                    ),
              ),
              themeMode: state.themeMode.toMaterialThemeMode(
                darkDuringDayInAutoMode: state.darkDuringDayInAutoMode,
              ),
              locale: state.appLanguague == AppLocalization.system
                  ? null
                  : Locale(state.appLanguague.name),
            ),
          );
        },
      ),
    );
  }
}
