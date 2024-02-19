// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  void _updateLanguage(String languageCode) {
    context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isLightTheme = themeProvider.getTheme() == ThemeData.light();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        children: <Widget>[
          ThemeSwitchListTile(
              isLightTheme: isLightTheme, themeProvider: themeProvider),
          const SizedBox(height: 24),
          Text(
            'change_language'.tr(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LanguageButton(
                languageCode: 'en',
                isSelected: context.locale.languageCode == 'en',
                onLanguageChange: _updateLanguage,
              ),
              LanguageButton(
                languageCode: 'ru',
                isSelected: context.locale.languageCode == 'ru',
                onLanguageChange: _updateLanguage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThemeSwitchListTile extends StatelessWidget {
  final bool isLightTheme;
  final ThemeProvider themeProvider;

  const ThemeSwitchListTile({
    Key? key,
    required this.isLightTheme,
    required this.themeProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(
        isLightTheme ? 'light_theme'.tr() : 'dark_theme'.tr(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Switch(
        activeColor: Colors.green,
        value: isLightTheme,
        onChanged: (value) {
          themeProvider.setTheme(value ? ThemeData.light() : ThemeData.dark());
        },
      ),
      leading: Icon(
        isLightTheme ? Icons.light_mode : Icons.dark_mode,
        color: isLightTheme ? Colors.yellow.shade600 : Colors.white,
        size: 28,
      ),
      onTap: () {
        themeProvider
            .setTheme(isLightTheme ? ThemeData.dark() : ThemeData.light());
      },
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String languageCode;
  final bool isSelected;
  final Function(String) onLanguageChange;

  const LanguageButton({
    Key? key,
    required this.languageCode,
    required this.isSelected,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onLanguageChange(languageCode),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: isSelected ? 8 : 4,
      ),
      child: Text(
        languageCode.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
