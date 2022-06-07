import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/screens/pokemon_details_screen.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/utils/utilities.dart';

class AllPokemons extends StatefulWidget {
  const AllPokemons({Key? key}) : super(key: key);

  @override
  _AllPokemonsState createState() => _AllPokemonsState();
}

class _AllPokemonsState extends State<AllPokemons>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final Future _fetchData;
  @override
  void initState() {
    super.initState();
    _fetchData = context.read<Pokemons>().fetchFromApi();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    return FutureBuilder(
        future: _fetchData,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3558CD),
              ),
            );
          }
          return ResponsiveBuilder(builder: (context, sizingInformation) {
            return Consumer<Pokemons>(builder: (context, pokemonObj, _) {
              return GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                crossAxisCount: sizingInformation.deviceScreenType ==
                        DeviceScreenType.tablet
                    ? 4
                    : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    getValue(sizingInformation, orientation, mediaQuery),
                children: [
                  ...pokemonObj.pokemons
                      .map((pokemon) => GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                PokemonDetailsScreen.routeName,
                                arguments: pokemon),
                            child: PokemonCard(
                              pokemon: pokemon,
                            ),
                          ))
                      .toList()
                ],
              );
            });
          });
        });
  }
}
