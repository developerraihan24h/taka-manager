import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/bottomnavbar/bottomnavbar.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/uihelper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    nameController = TextEditingController(text: settingsProvider.userName);
    if (settingsProvider.profileImagePath != null) {
      _image = File(settingsProvider.profileImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(fontSize: 20.sp)),
        automaticallyImplyLeading: !settingsProvider.isFirstTime,
      ),
      body: Padding(
        padding: EdgeInsets.all(20).r,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (settingsProvider.isFirstTime)
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: uiHelper.CustomText(
                    text: "Welcome! Please set up your profile.",
                    fontSize: 18.sp,
                    fontweight: FontWeight.bold,
                  ),
                ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt,
                          size: 40.r, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20.h),
              uiHelper.customTextField(
                controller: nameController,
                text: "Enter your name",
                tohide: false,
                textinputtype: TextInputType.text,
              ),
              SizedBox(height: 20.h),

              // Language Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Language",
                      style:
                          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: settingsProvider.locale.languageCode,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text("English")),
                      DropdownMenuItem(value: 'bn', child: Text("Bangla")),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        settingsProvider.setLocale(Locale(value));
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Currency Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Currency",
                      style:
                          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: settingsProvider.currency,
                    items: const [
                      DropdownMenuItem(value: '৳', child: Text("BDT (৳)")),
                      DropdownMenuItem(value: '\$', child: Text("USD (\$)")),
                      DropdownMenuItem(value: '€', child: Text("EUR (€)")),
                      DropdownMenuItem(value: '£', child: Text("GBP (£)")),
                      DropdownMenuItem(value: '₹', child: Text("INR (₹)")),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        settingsProvider.setCurrency(value);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              uiHelper.customButton(
                callback: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your name")),
                    );
                    return;
                  }

                  final bool wasFirstTime = settingsProvider.isFirstTime;

                  await settingsProvider.updateProfile(
                    nameController.text,
                    _image?.path,
                  );

                  if (!mounted) return;

                  if (wasFirstTime) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Bottomnavbar()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                buttonname: settingsProvider.isFirstTime ? "Get Started" : "Save Changes",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
