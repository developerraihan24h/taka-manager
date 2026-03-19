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

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppsColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: uiHelper.customImage(imgurl: "takamanager.png"),
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
              color: AppsColors.secondaryBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: settingsProvider.profileImagePath != null
                  ? Image.file(
                      File(settingsProvider.profileImagePath!),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person_outlined,
                      color: Colors.black,
                    ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade200,
          height: 1,
        ),
      ),
    );
  }
}
