import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/profile/views/profile.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../core/appscolors.dart';
import '../uihelper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final isDark = settingsProvider.isDarkMode;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppsColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: uiHelper.customImage(imgurl: "tkmanager_icon.png"),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            AppLocalizations.of(context)!.appname,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "bold",
              color: AppsColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: isDark,
            onChanged: (value) {
              settingsProvider.toggleTheme(value);
            },
            activeColor: isDark ? Colors.black : Colors.white,
            activeTrackColor: isDark ? Colors.white : Colors.black,
            inactiveTrackColor: isDark ? Colors.white : Colors.black,
            inactiveThumbColor: isDark ? Colors.black : Colors.white,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Profile()));
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : AppsColors.secondaryBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: settingsProvider.profileImagePath != null
                  ? Image.file(
                      File(settingsProvider.profileImagePath!),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person_outlined,
                      color: isDark ? Colors.white : Colors.black,
                    ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark ? Colors.grey[700] : Colors.grey.shade200,
          height: 1,
        ),
      ),
    );
  }
}
