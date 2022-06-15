import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utils/utilities.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(left: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(color: color ?? Colors.grey[200]),
            width: double.infinity,
            height: constraints.maxHeight * 0.55,
            child: Hero(
              tag: widget.pokemon.id,
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.imageUrl,
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
            widget.pokemon.id.toString().length == 1
                ? widget.pokemon.id.toString().padLeft(2, "#00")
                : widget.pokemon.id.toString().padLeft(3, '#0'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Text(
            widget.pokemon.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          FittedBox(
            child: Text(
              removeBrackets(widget.pokemon.types.toString()),
              style: Theme.of(context).textTheme.bodyText1,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}
