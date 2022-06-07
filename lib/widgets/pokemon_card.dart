import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utils/utilities.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({
    Key? key,
    required this.pokemon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(left: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(color: pokemon.color),
            width: double.infinity,
            height: constraints.maxHeight * 0.55,
            child: Hero(
              tag: pokemon.id.toString(),
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, _) => Container(
                  height: constraints.maxHeight * 0.55,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Text(
            pokemon.id.toString().length == 1 ? pokemon.id.toString().padLeft(2, "#00") : pokemon.id.toString().padLeft(3, '#0'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Text(
            pokemon.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          FittedBox(
            child: Text(
              removeBraces(pokemon.types.toString()),
              style: Theme.of(context).textTheme.bodyText1,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}
