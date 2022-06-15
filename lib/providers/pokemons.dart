import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:dio/dio.dart';

class Pokemons with ChangeNotifier {
  final List<Pokemon> _pokemons = [];
  List<Pokemon> _favoritePokemons = [];
  String _url = 'https://pokeapi.co/api/v2/pokemon?limit=11';
  final Dio _dio;
  final SharedPreferences _prefs;
  Pokemons(this._dio, this._prefs);
  List<Pokemon> get pokemons {
    return [..._pokemons];
  }

  String get url => _url;

  List<Pokemon> get favoritePokemons {
    return [..._favoritePokemons];
  }

  Future<String?> fetchFromApi() async {
    try {
      final response = await _dio.get(_url);
      if (response.statusCode! >= 400) {
        return null;
      }
      final List<Map<String, dynamic>> responseData =
          List<Map<String, dynamic>>.from(response.data['results']);
      _url = response.data['next']; // to set url for next set of pokemons(20)
      for (var jsonPokemon in responseData) {
        final pokemon = await getPokemonObj(jsonPokemon['url'] as String);
        if (pokemon != null) {
          _pokemons.add(pokemon);
        }
      }
      await _getFavorites();
      notifyListeners();
      return 'successful';
    } catch (_) {
      return null;
    }
  }

  Future<Pokemon?> getPokemonObj(String url) async {
    try {
      final prefsFavorites = _prefs.getStringList('favorites') ?? [];
      final response = await _dio.get(url);
      if (response.statusCode! >= 400) {
        return null;
      }
      final Map<String, dynamic> responseData = response.data;
      return Pokemon.fromJson(
          responseData, prefsFavorites.contains(responseData['name']));
    } catch (_) {
      return null;
    }
  }

  Future<String> toggleFavorites(Pokemon pokemon) async {
    final prefsFavorites = _prefs.getStringList('favorites') ?? [];
    var message = '';
    if (prefsFavorites.contains(pokemon.name)) {
      prefsFavorites.remove(pokemon.name);
      _prefs.setStringList('favorites', prefsFavorites);
      _favoritePokemons.remove(pokemon);
      message = 'Removed from favorite list';
    } else {
      prefsFavorites.add(pokemon.name);
      _prefs.setStringList('favorites', prefsFavorites);
      _favoritePokemons.add(pokemon);
      message = 'Added to favorite list';
    }
    pokemon.isFavorite = !pokemon.isFavorite;
    notifyListeners();
    return message;
  }

  Future<void> _getFavorites() async {
    _favoritePokemons =
        _pokemons.where((element) => element.isFavorite).toList();
    var prefsFavorites = _prefs.getStringList('favorites') ?? [];
    for (var pokemon in _favoritePokemons) {
      if (prefsFavorites.contains(pokemon.name)) {
        prefsFavorites.remove(pokemon.name);
      }
    }
    for (var pokemonName in prefsFavorites) {
      final pokemon =
          await getPokemonObj('https://pokeapi.co/api/v2/pokemon/$pokemonName');
      if (pokemon != null) {
        _favoritePokemons.add(pokemon);
      }
    }
  }

  int get favoritiesLength {
    return _favoritePokemons.length;
  }
}
