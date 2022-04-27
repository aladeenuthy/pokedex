import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/widgets/badge.dart';
import 'package:pokedex/widgets/all_pokemons.dart';
import 'package:pokedex/widgets/favorite_pokemons.dart';

class TabletScreen extends StatefulWidget {
  const TabletScreen({Key? key}) : super(key: key);

  @override
  _TabletScreenState createState() => _TabletScreenState();
}

class _TabletScreenState extends State<TabletScreen> {
  var _index = 0;
  List screens = [
    const AllPokemons(), const FavoritePokemons()
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          
          ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(children: [
              NavigationRail(
                unselectedLabelTextStyle: const TextStyle(fontSize: 15),
                selectedLabelTextStyle: const TextStyle(fontSize: 17, color: Color(0xFF3558CD)),
                minWidth: constraints.maxWidth * 0.15,
                groupAlignment: 0.0,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  const NavigationRailDestination(
                      icon: Text(""),
                      label: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: RotatedBox(child: Text("All Pokemons"), quarterTurns: -1,),
                      ),
                      ),
                  NavigationRailDestination(icon: const Text(""), label: RotatedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Favorite pokemons",
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
                      quarterTurns: -1,
                    ), ),
                  
                ],
                selectedIndex: _index,
                onDestinationSelected: (selectedIndex) {
                  setState(() {
                    _index = selectedIndex;
                  });
                },
              ),
            Expanded(child: screens[_index] )
            ]);
          }
        ),
      ),
    );
  }
}
