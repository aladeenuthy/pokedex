import 'package:flutter/material.dart';
import 'package:pokedex/screens/tab_screen.dart';
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
          
        ),
        home: TabScreen()
      ),
    );
  }
}
