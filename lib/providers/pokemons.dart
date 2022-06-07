import 'package:flutter/material.dart';
import 'package:pokedex/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

class Pokemons with ChangeNotifier {
  final List<Pokemon> _pokemons = [];
  String _url = 'https://pokeapi.co/api/v2/pokemon?limit=20';


  Future<void> fetchFromApi() async {
    try {
      final response = await Dio().get(_url);
      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response.data['results']);
      _url = response.data['next']; // to set url for next set of pokemons(20)
      for (var jsonPokemon in responseData) {
        final pokemon = await getPokemonObj(jsonPokemon['url'] as String);
        _pokemons.add(pokemon);
      }
      notifyListeners();
    } catch (_) {}
  }

  List<Pokemon> get pokemons {
    return [..._pokemons];
  }

  Future<Pokemon> getPokemonObj(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await Dio().get(url);
    final Map<String, dynamic> responseData = response.data;
    final color = await getDominantColor(
        responseData['sprites']['other']['official-artwork']['front_default']);
    return Pokemon.fromJson(responseData,
        prefs.getBool(responseData['name']) ?? false, color ?? Colors.grey);
  }



  Future<void> toggleFavorites(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final isFavorite = prefs.getBool(name) ?? false;
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
