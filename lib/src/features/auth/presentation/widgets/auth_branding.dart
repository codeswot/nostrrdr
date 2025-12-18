import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBranding extends StatelessWidget {
  const AuthBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: .center,
      children: [
        FlutterLogo(size: 250.h),
        SizedBox(height: 20.h),
        Text('Nostrrdr', style: TextStyle(fontSize: 30.sp)),
      ],
    );
  }
}
