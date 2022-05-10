import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => NP(),
      child: ThemeProvider(
          initTheme: savedtheme,
          duration: const Duration(milliseconds: 400),
          builder: (context, mythemes) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Notes app',
                theme: mythemes,
                home: const Home(),
              )));
}
