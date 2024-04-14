import 'package:flutter/material.dart';
import 'home.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'port.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  DartPingIOS.register();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('en');
  //add delay to show splash screen
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();


  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
