import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takamanager/core/appscolors.dart';

class uiHelper {
  static CustomText({
    required String text,
    required double fontSize,
    Color? color,
    FontWeight? fontweight,
    String? fontfamily,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        color: color ?? Colors.black,
        fontWeight: fontweight,
        fontFamily: fontfamily,
      ),
    );
  }

  //===========================
  static customTextField({
    required TextEditingController controller,
    required String text,
    required bool tohide,
    required TextInputType textinputtype,
  }) {
    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppsColors.secondaryBackground,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: TextField(
          controller: controller,
          obscureText: tohide,
          keyboardType: textinputtype,
          style: TextStyle(fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: AppsColors.textcolorBlack,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  //=========================================
  static customImage({required String imgurl}) {
    return Image.asset("assets/images/$imgurl");
  }

  //===============
  static customButton({
    required VoidCallback callback,
    required String buttonname,
  }) {
    return SizedBox(
      height: 50.h,
      width: 300.w,
      child: ElevatedButton(
        onPressed: () {
          callback();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppsColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          buttonname,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppsColors.textcolorWhite,
            fontFamily: "bold",
          ),
        ),
      ),
    );
  }

  //==================================================
  static Widget customTextFieldCommon({
    required TextEditingController controller,
    required String text,
    String? labelText,
    required bool tohide,
    required TextInputType textinputtype,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: TextField(
        controller: controller,
        obscureText: tohide,
        keyboardType: textinputtype,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: text,
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 16.sp, color: AppsColors.primary),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.r),
          ),
        ),
      ),
    );
  }
}
