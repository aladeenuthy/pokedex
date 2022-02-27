import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonCard extends StatelessWidget {
  final String id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final Color color;
  const PokemonCard({
    Key? key,
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.color
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(left: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
                  decoration: BoxDecoration(color: color),
                  width: double.infinity,
                  height: constraints.maxHeight * 0.55,
                  child: Hero(
                    tag: id,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, _) =>  Container(
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
            id.length == 1
                ? id.padLeft(2, "#00")
                : id.padLeft(3, '#0'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          FittedBox(
            child: Text(
              types.toString().replaceAll("[", '').replaceAll(']', ''),
              style: Theme.of(context).textTheme.bodyText1,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}
