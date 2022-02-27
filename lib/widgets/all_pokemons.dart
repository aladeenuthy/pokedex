import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/screens/pokemon_details_screen.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class AllPokemons extends StatefulWidget {
  const AllPokemons({Key? key}) : super(key: key);

  @override
  _AllPokemonsState createState() => _AllPokemonsState();
}

class _AllPokemonsState extends State<AllPokemons> {
  Future? _fetchData;
  @override
  void initState() {
    _fetchData = Provider.of<Pokemons>(context, listen: false).fetchFromApi();
    super.initState();
  }

  double getValue(SizingInformation sizingInformation, Orientation orientation,
      MediaQueryData mediaQuery) {
    if (sizingInformation.deviceScreenType == DeviceScreenType.tablet ||
        orientation == Orientation.landscape) {
      return 1.0;
    } else {
      return (mediaQuery.size.width / mediaQuery.size.height / 1.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    return Consumer<Pokemons>(
      builder: (context, pokemonObj, _) => FutureBuilder(
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
              return GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                crossAxisCount: sizingInformation.deviceScreenType ==
                        DeviceScreenType.tablet
                    ? 5
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
                              id: pokemon.id.toString(),
                              name: pokemon.name,
                              types: pokemon.types,
                              imageUrl: pokemon.imageUrl,
                              color: pokemon.color,
                            ),
                          ))
                      .toList()
                ],
              );
            });
          }),
    );
  }
}
