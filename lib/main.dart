import 'package:easeyydeal/firebase_options.dart';
import 'package:easeyydeal/src/core/utils/data.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.getThemeStream().listen((theme) {
      print("dsbjfgkjdfhg  ${theme}");
      Provider.of<ThemeProvider>(context, listen: false).updateTheme(theme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Theme')),
      body: Center(child: Text('Hello, Flutter!')),
    );
  }
}
