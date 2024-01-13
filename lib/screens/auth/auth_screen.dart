import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import 'auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/authentication';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.authentication),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 20),
              width: double.infinity,
              child: const FlutterLogo(
                size: 150,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: AuthenticationForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
