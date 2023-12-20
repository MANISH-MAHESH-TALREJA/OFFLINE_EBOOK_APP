import 'package:srila_prabhupada_books/helper/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

const String languageCodeConstant = 'languageCode';
const String english = 'en';
const String hindi = 'hi';

Locale? loc;
int lang = 0;
Future<Locale> setLocale(String languageCode) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCodeConstant, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(languageCodeConstant) ?? "en";
  languageFlag = languageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode)
{
  switch (languageCode)
  {
    case english:
      return const Locale(english, 'US');
    case hindi:
      return const Locale(hindi, "IN");
    default:
      return const Locale(english, 'US');
  }
}

void changeLanguage(BuildContext context, String language) async
{
  languageFlag = language;
  Locale loc = await setLocale(language);
  if(!context.mounted)
  {
    return;
  }
  MyApp.setLocale(context, loc);
}
