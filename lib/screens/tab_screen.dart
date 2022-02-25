import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12.0),
                //   child: null,
                // ),
                // const SizedBox(width: 3),
                Text(
                  "AOT",
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
            bottom: const TabBar(
                indicatorColor: Color(0xFF3558CD),
                labelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: "All pokemons",
                  ),
                  Tab(
                    text: 'Favorite pokemons',
                  )
                ]),
          ),
          body: TabBarView(children: [Container(), Container()]),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Provider.of<Pokemons>(context, listen: false).fetchFromApi();
            },
          ),
        ));
  }
}
