import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/utils/utilities.dart';
import 'package:pokedex/widgets/pokemon_stat.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  static const routeName = '/pokemon-details';
  const PokemonDetailsScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  Color? color;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      color = await getDominantColor(widget.pokemon.imageUrl);
      setState(() {
        
      });
    });
  }

  Widget buildAttribute(String name, String value, BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: color ?? Colors.grey[200],
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: pokemon.id,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(pokemon.imageUrl),
                            fit: BoxFit.contain)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Container()),
                          Text(
                            pokemon.name,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(removeBrackets(pokemon.types.toString()),
                              style: Theme.of(context).textTheme.headline4),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            pokemon.id.toString().length == 1
                                ? pokemon.id.toString().padLeft(2, "#00")
                                : pokemon.id.toString().padLeft(3, '#0'),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.only(left: 30, bottom: 10, top: 15),
                  color: Colors.white,
                  child: Row(children: [
                    buildAttribute(
                        'Height', pokemon.height.toString(), context),
                    const SizedBox(
                      width: 10,
                    ),
                    buildAttribute('Weight', pokemon.weight.toString(), context)
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Base stats",
                            style: Theme.of(context).textTheme.headline3),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(
                          height: 12,
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        ...pokemon.stats.map((stat) {
                          var index = pokemon.stats.indexOf(stat);
                          return PokemonStat(stat: stat, index: index);
                        }).toList()
                      ]),
                )
              ]),
            )
          ],
        ),
        floatingActionButton: Consumer<Pokemons>(
          builder: (context, pokemons, _) => FloatingActionButton(
            backgroundColor: const Color(0xFF3558CD),
            onPressed: () async {
              await pokemons.toggleFavorites(pokemon);
            },
            child: Icon(
                pokemon.isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ));
  }
}
