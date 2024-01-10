import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlatformElevatedButton(
        child: const Text('Test'),
        onPressed: () => context.push(AuthScreen.routeName),
      ),
    );
  }
}
