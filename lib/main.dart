import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helper/app_constants.dart';
import 'Helper/strings.dart';
import 'screens/splash_screen.dart';
import 'localization/demo_localization.dart';
import 'localization/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}
// global variable for language define here

class MyAppState extends State<MyApp> {
  SharedPreferences? prefs;

  Locale? _locale;
  bool? lan;
  @override
  initState() {
    getDarkMode();
    super.initState();
  }

  setLocale(Locale locale) {
    setState(
      () {
        _locale = locale;
      },
    );
  }

  @override
  void didChangeDependencies() {
    setState(
      () {
        getLocale().then(
          (locale) {
            setState(
              () {
                _locale = locale;
              },
            );
          },
        );
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: darkMode
          ? ThemeData(brightness: Brightness.light, fontFamily: "Poppins")
          : ThemeData(brightness: Brightness.dark, fontFamily: "Poppins"),
      locale: _locale,
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", "US"),
        Locale("hi", "IN"),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }

  //set title for indicator page
  getDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    darkMode = preferences.getBool("DARK MODE") ?? true;
    return darkMode;
  }
}
