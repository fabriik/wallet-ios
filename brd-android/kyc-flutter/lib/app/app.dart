// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kyc/common/app_theme.dart';
import 'package:kyc/common/dependency_provider.dart';
import 'package:kyc/kyc/view/kyc_onboarding_page.dart';
import 'package:kyc/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void sendResultToNative(dynamic res) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      navigatorKey: DependencyProvider.of(context).navigationCubit.navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const KycOnboardingPage(),
    );
  }

  @override
  void dispose() {
    DependencyProvider.of(context).dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
