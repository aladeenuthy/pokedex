import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/screens/mobile_screen.dart';
import 'package:pokedex/screens/tablet_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/pokemons.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Pokemons(Dio(), prefs),
      child: MaterialApp(
        title: 'Pokedex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline3: ThemeData.light().textTheme.headline3!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                headline4: ThemeData.light().textTheme.headline4!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                bodyText1: ThemeData.light().textTheme.bodyText1!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12))),
        home: ScreenTypeLayout.builder(
            mobile: (BuildContext context) => const MobileScreen(),
            tablet: (BuildContext context) => const TabletScreen()),
      ),
    );
  }
}
