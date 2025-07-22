import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/services/service_locator.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await ServiceLocator.init();
  
  runApp(
    GetMaterialApp(
      title: "Lucid",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
