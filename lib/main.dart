import 'package:flutter/material.dart';
import 'package:pokedex/screens/pokemon_details_screen.dart';
import 'package:pokedex/screens/mobile_screen.dart';
import 'package:pokedex/screens/tablet_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'providers/pokemons.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Pokemons(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline3: ThemeData.light().textTheme.headline3!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
            headline4: ThemeData.light().textTheme.headline4!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ), 
            bodyText1: ThemeData.light().textTheme.bodyText1!.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12
            )
          )
        ),
        home: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const MobileScreen(),
          tablet: (BuildContext context) => const TabletScreen()
        ),
        routes: {
          PokemonDetailsScreen.routeName: (context) => const PokemonDetailsScreen()
        },
      ),
    );
  }
}
