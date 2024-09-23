import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticket_number/screens/home_screen.dart';
import 'package:ticket_number/screens/test.dart';
import 'features/screens/addVoucher/add_voucher_screen.dart';
import 'features/screens/voucher_details_screen.dart';
import 'features/models/voucher.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';
import 'package:ticket_number/screens/splash_screen.dart';
import 'core/services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS ) {
  //   sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  // }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme, // Use light theme here
      //darkTheme: AppTheme.darkTheme,  // Optional: Add dark theme
      //themeMode: ThemeMode.system,  // Automatically switch between light and dark based on system settings
      navigatorKey: navigationService.navigatorKey, // Set the navigator key
      onGenerateRoute: _generateRoute, // Optionally, setup named routes
      home: SplashScreen(),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/add-voucher':
        return MaterialPageRoute(builder: (context) => AddVoucherScreen());
      case '/voucher-details':
        final voucher = settings.arguments as Voucher;
        return MaterialPageRoute(
            builder: (context) => VoucherDetailsScreen(voucher: voucher));
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      // Add other routes here
      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
