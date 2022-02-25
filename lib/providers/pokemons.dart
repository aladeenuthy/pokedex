import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

class Pokemons with ChangeNotifier {
  final List<Pokemon> _pokemons = [];
  Future<void> fetchFromApi() async {
    const url = 'https://pokeapi.co/api/v2/pokemon?limit=20';
    final response = await Dio().get(url);
    final List<dynamic> responseData = response.data['results'];
    for (var res in responseData) {
      final pokemon = await getPokemonObj(res['url']);
      _pokemons.add(pokemon);
    }
    notifyListeners();
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
    return Pokemon(
        id: responseData['id'],
        name: responseData['name'],
        height: responseData['height'],
        weight: responseData['weight'],
        imageUrl: responseData['sprites']['other']['official-artwork']
                ['front_default'] ??
            '',
        types: types,
        stats: stats,
        isFavorite: prefs.getBool(responseData['name']) ?? false);
  }
}
