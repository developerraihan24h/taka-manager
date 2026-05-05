import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeveloperInfoPage extends StatelessWidget {
  const DeveloperInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Information"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/raihanpic.jpg"),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Md Abu Raihan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Flutter Mobile App Developer",
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
                  ),
                ],
              ),
            ),

             SizedBox(height: 10.h),

            // About Section
            _buildSection(
              context,
              title: "About",
              content:
              "Passionate Flutter developer with experience in app development, video editing, and digital marketing. Focused on building modern and user-friendly applications.",
            ),

            // Skills Section
            _buildSection(
              context,
              title: "Skills",
              content:
              "• Flutter\n• Dart\n• Firebase\n• UI/UX Design\n",
            ),

            // Contact Section
            _buildSection(
              context,
              title: "Contact",
              content:
              "Email: dev.raihan24h@email.com\nWebsite: topwaysolution.com\nPhone: +8801701060008",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
          ),
        ],
      ),
    );
  }
}
