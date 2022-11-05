import 'dart:io';

import 'package:ebutler_task/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Locale deviceLocale = Locale(Platform.localeName.substring(0, 2));
Locale englishLocale = const Locale('en');
Locale arabicLocale = const Locale('ar');


final size = MediaQuery.of(NavigationService.context!).size;
final double largeSpace = 100.sp;
