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
        Provider.of<Pokemons>(context).favoritePokemons;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                sizingInformation.deviceScreenType == DeviceScreenType.tablet
                    ? 4
                    : 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio:
                getValue(sizingInformation, orientation, mediaQuery)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: pokemons.length,
        itemBuilder: (_, index) => GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> PokemonDetailsScreen(pokemon: pokemons[index]))),
          child: PokemonCard(
            pokemon: pokemons[index],
          ),
        ),
      );
      }
    );
  }
}
