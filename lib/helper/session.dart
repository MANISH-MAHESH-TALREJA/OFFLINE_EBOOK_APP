import 'package:shared_preferences/shared_preferences.dart';

setDarkMode(bool darkMode) async
{
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setBool("DARK MODE", darkMode);
}
