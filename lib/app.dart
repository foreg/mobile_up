import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_up/generated/l10n.dart';
import 'package:mobile_up/screens/home.dart';
import 'package:mobile_up/screens/login.dart';
import 'package:provider/provider.dart';

import 'data/models/app_state.dart';

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authModel,
  }) : super(key: key);

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final AppState authModel;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
    );
    final darkTheme = ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white24),
        ),
      ),
    );
    return ChangeNotifierProvider<AppState>.value(
      value: authModel,
      child: MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        scaffoldMessengerKey: _messangerKey,
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Consumer<AppState>(
          builder: (context, model, _) {
            if (model.hasToken) return const Home();
            return const Login();
          },
        ),
      ),
    );
  }
}
