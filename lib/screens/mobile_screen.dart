import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/widgets/all_pokemons.dart';
import 'package:pokedex/widgets/badge.dart';
import 'package:pokedex/widgets/favorite_pokemons.dart';
import 'package:provider/provider.dart';


class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 30,
                    child: SvgPicture.asset('assets/images/pokemon.svg'),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "Pokedex",
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            ),
            bottom: TabBar(
                indicatorColor: const Color(0xFF3558CD),
                labelColor: Colors.black,
                labelStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                tabs: [
                  const Tab(
                    text: "All pokemons",
                  ),
                  Tab(
                    child: Row(
                        mainAxisAlignment: orientation == Orientation.landscape ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Favorite pokemons",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Consumer<Pokemons>(builder: (context, pokemonObj, _) {
                            if (pokemonObj.favoritiesLength > 0) {
                              return Badge(
                                  value:
                                      pokemonObj.favoritiesLength.toString());
                            }
                            return const Text('');
                          })
                        ]),
                  )
                ]),
          ),
          body: const TabBarView(children: [AllPokemons(), FavoritePokemons()]),
        )
      );
  }
}
