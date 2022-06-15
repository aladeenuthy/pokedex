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

  var isLoading = false;
  Future? _fetchData;
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetchData = context.read<Pokemons>().fetchFromApi();
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset &&
          !isLoading) {
        setState(() {
          isLoading = true;
        });
        await context.read<Pokemons>().fetchFromApi();
        setState(() {
          isLoading = false;
        });
      }
    });
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
          } else if (snapShot.hasData) {
            return ResponsiveBuilder(builder: (context, sizingInformation) {
              return Consumer<Pokemons>(builder: (context, pokemonObj, _) {
                return GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: sizingInformation.deviceScreenType ==
                              DeviceScreenType.tablet
                          ? 4
                          : 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          getValue(sizingInformation, orientation, mediaQuery)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: pokemonObj.pokemons.length + 1,
                  itemBuilder: (_, index) {
                    if (index == pokemonObj.pokemons.length) {
                      return isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF3558CD)),
                            )
                          : Container();
                    } else {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PokemonDetailsScreen(
                                    pokemon: pokemonObj.pokemons[index]))),
                        child: PokemonCard(
                          pokemon: pokemonObj.pokemons[index],
                        ),
                      );
                    }
                  },
                );
              });
            });
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Something went wrong",
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF3558CD)),
                  onPressed: () {
                    setState(() {
                      _fetchData = Provider.of<Pokemons>(context, listen: false)
                          .fetchFromApi();
                    });
                  },
                  child:
                      const Text('Try again', style: TextStyle(fontSize: 17)))
            ],
          );
        });
  }
}
