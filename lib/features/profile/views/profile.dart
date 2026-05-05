import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/profile/views/edit_profile.dart';
import 'package:takamanager/features/profile/widgets/webview.dart';
import 'package:takamanager/features/uihelper.dart';

import '../../../core/appscolors.dart';
import '../../../l10n/app_localizations.dart';
import 'developer_info.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void shareApp() {
    Share.share(
      "Check out this amazing app: https://play.google.com/store/apps/details?id=com.topwaysolution.takamanager",
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryBg = isDark ? Colors.grey.shade800 : AppsColors.secondaryBackground;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            uiHelper.CustomText(
              text: AppLocalizations.of(context)!.profile,
              fontSize: 20,
              fontfamily: "bold",
              context: context,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Theme.of(context).dividerColor, height: 1),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: settingsProvider.profileImagePath != null
                    ? FileImage(File(settingsProvider.profileImagePath!))
                    : null,
                child: settingsProvider.profileImagePath == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              uiHelper.CustomText(
                text: settingsProvider.userName,
                fontSize: 20,
                fontweight: FontWeight.bold,
                context: context,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                child: topRadiusContainer(Icons.edit, "Edit Profile", secondaryBg),
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                        url: "https://sites.google.com/view/taka-manager/",
                      ),
                    ),
                  );
                },
                child: plainContainer(Icons.info_outline, "Privacy Policy", secondaryBg),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  shareApp();
                },
                child: plainContainer(Icons.share, "Share App", secondaryBg),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeveloperInfoPage(),
                    ),
                  );
                },
                child: plainContainer(
                  Icons.person_outline,
                  "Developer Information",
                  secondaryBg,
                ),
              ),
              const SizedBox(height: 5),
              bottomRadiusContainer(Icons.settings, "Setting", secondaryBg),
            ],
          ),
        ),
      ),
    );
  }

  Widget topRadiusContainer(IconData icon, String btText, Color bgColor) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: AppsColors.primary),
            const SizedBox(width: 5),
            uiHelper.CustomText(
              text: btText,
              fontSize: 16,
              fontweight: FontWeight.bold,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget plainContainer(IconData icon, String btText, Color bgColor) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(color: bgColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: AppsColors.primary),
            const SizedBox(width: 5),
            uiHelper.CustomText(
              text: btText,
              fontSize: 16,
              fontweight: FontWeight.bold,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomRadiusContainer(IconData icon, String btText, Color bgColor) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: AppsColors.primary),
            const SizedBox(width: 5),
            uiHelper.CustomText(
              text: btText,
              fontSize: 16,
              fontweight: FontWeight.bold,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
