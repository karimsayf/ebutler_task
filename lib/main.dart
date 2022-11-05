import 'package:ebutler_task/screens/authentication/authentication.dart';
import 'package:ebutler_task/screens/home.dart';
import 'package:ebutler_task/services/desk_storage.dart';
import 'package:ebutler_task/services/navigation_services.dart';
import 'package:ebutler_task/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'services/service_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSecureStorage();
  await Hive.initFlutter();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ServiceProvider>(
      create: (context) => ServiceProvider(),
    ),
    ChangeNotifierProvider<DeskStorage>(
      create: (context) => DeskStorage(),
    ),
  ],
      child: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _getAuthUser = Provider.of<DeskStorage>(context,listen: false).getAuthUser();
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) =>  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EButler Task',
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<dynamic>(
          future:_getAuthUser ,
          builder: (context, snapshot) {
            if(snapshot.hasData){

              if(snapshot.data['lastLogin'] == null || snapshot.data['lastLogin'].isBefore(DateTime.now().subtract(Duration(hours: 1))) ){
                return Authentication();
              }
              return Home();
            }
            return Container();
          },
        )
      ),
    );
  }
}

