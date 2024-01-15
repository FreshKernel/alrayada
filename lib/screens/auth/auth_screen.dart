import 'package:flutter/material.dart';

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
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const FlutterLogo(
                size: 150,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: AuthenticationForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
