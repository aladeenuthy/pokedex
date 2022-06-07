import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:provider/provider.dart';
import '../screens/pokemon_details_screen.dart';
import '../utils/utilities.dart';
import 'pokemon_card.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FavoritePokemons extends StatelessWidget {
  const FavoritePokemons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    final pokemons =
        Provider.of<Pokemons>(context).getFavorites();
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          crossAxisCount: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 4 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: getValue(sizingInformation, orientation, mediaQuery),
          children: [
            ...pokemons
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
      }
    );
  }
}
