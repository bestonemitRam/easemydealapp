import 'package:easeyydeal/src/core/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void updateTheme(String theme) 
  {
   
    if (theme == 'dark') 
    {
      _themeData = darkTheme;
    }
     else 
     {
      _themeData = lightTheme;
    }
    notifyListeners();
  }
}
