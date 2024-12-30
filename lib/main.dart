import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easeyydeal/firebase_options.dart';
import 'package:easeyydeal/src/core/utils/data.dart';
import 'package:easeyydeal/src/presentation/home_screen.dart';
import 'package:easeyydeal/src/provider/ThemeProvider.dart';
import 'package:easeyydeal/src/repo/services/ThemeService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await Firebase.initializeApp(
      name: "easeyydeal", options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(lightTheme),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

