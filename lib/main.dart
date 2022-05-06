import 'package:flutter/material.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/theme.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NP(),
      child: ThemeProvider(
        initTheme: initialTheme,
        builder: (context, mythemes) => MaterialApp(
          title: 'Notes app',
          theme: mythemes,
          home: const Home(),
        ),
      ),
    );
  }
}
