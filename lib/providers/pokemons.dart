import 'package:flutter/material.dart';
import 'package:pokedex/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

class Pokemons with ChangeNotifier {
  final List<Pokemon> _pokemons = [];
  Future<void> fetchFromApi() async {
    if (_pokemons.isNotEmpty) {
      return;
    }
    try{
      const url = 'https://pokeapi.co/api/v2/pokemon?limit=20';
      final response = await Dio().get(url);
      final List<dynamic> responseData = response.data['results'];
      for (var res in responseData) {
        final pokemon = await getPokemonObj(res['url']);
        _pokemons.add(pokemon);
      }
      notifyListeners();
    }catch(_){
    }
  }

  List<Pokemon> get pokemons {
    return [..._pokemons];
  }

  Future<Pokemon> getPokemonObj(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await Dio().get(url);
    final Map<String, dynamic> responseData = response.data;
    List<Stat> stats = [];
    List<String> types = [];
    final List<dynamic> res = responseData['stats'];
    final List<dynamic> resTypes = responseData['types'];
    stats = res
        .map(
          (stat) =>
              Stat(name: stat['stat']['name'], baseStat: stat['base_stat']),
        )
        .toList();
    types = resTypes.map((type) => type['type']['name'] as String).toList();
    final color = await getDominantColor(
        responseData['sprites']['other']['official-artwork']['front_default']);
    return Pokemon(
        id: responseData['id'],
        name: responseData['name'],
        height: responseData['height'],
        weight: responseData['weight'],
        imageUrl: responseData['sprites']['other']['official-artwork']
            ['front_default'],
        types: types,
        stats: stats,
        color: color ?? Colors.grey,
        isFavorite: prefs.getBool(responseData['name']) ?? false);
  }

  Future<void> toggleFavorites(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final isFavorite = prefs.getBool(name) ?? false ;
    await prefs.setBool(name, !isFavorite);
    final pokemon = _pokemons.firstWhere((element) => element.name == name);
    pokemon.isFavorite = !isFavorite;
    notifyListeners();
  }

  List<Pokemon> getFavorites() {
    final _favoritePokemons =
        _pokemons.where((element) => element.isFavorite == true);
    return [..._favoritePokemons];
  }

  int get favoritiesLength {
    return getFavorites().length;
  }
}
