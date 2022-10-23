import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'db/db_helper.dart';
import 'services/theme_service.dart';
import 'ui/pages/home_page.dart';
import 'ui/widgets/themes.dart';

// final notification = NotifyHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await notification.initializeTimeZone();
  // await notification.initializeNotification();

  await DBHelper.initDb();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,

      home: const HomePage(),
    );
  }
}
