import 'package:bet_manager_app/controllers/transaction_controller.dart';
import 'package:bet_manager_app/controllers/filter_controller.dart';
import 'package:bet_manager_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionController()),
        ChangeNotifierProvider(create: (context) => FilterController()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: <Locale>[
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          title: 'Bet Manager',
          home: MainScreen(),
        );
      }
    );
  }
}