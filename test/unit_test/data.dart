import 'package:pokedex/models/pokemon.dart';

Map<String, dynamic> pokemonResponse = {
  "count": 1126,
  "next": "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1",
  "previous": null,
  "results": [
    {"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}
  ]
};
Map<String, dynamic> pokemonData = {
  'id': 1,
  "name": "bulbasaur",
  'height': 22,
  "stats": [
    {
      "base_stat": 45,
      "effort": 0,
      "stat": {"name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/"}
    },
    {
      "base_stat": 49,
      "effort": 0,
      "stat": {"name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/"}
    },
    {
      "base_stat": 49,
      "effort": 0,
      "stat": {"name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/"}
    },
    {
      "base_stat": 65,
      "effort": 1,
      "stat": {
        "name": "special-attack",
        "url": "https://pokeapi.co/api/v2/stat/4/"
      }
    },
    {
      "base_stat": 65,
      "effort": 0,
      "stat": {
        "name": "special-defense",
        "url": "https://pokeapi.co/api/v2/stat/5/"
      }
    },
    {
      "base_stat": 45,
      "effort": 0,
      "stat": {"name": "speed", "url": "https://pokeapi.co/api/v2/stat/6/"}
    }
  ],
  "types": [
    {
      "slot": 1,
      "type": {"name": "grass", "url": "https://pokeapi.co/api/v2/type/12/"}
    },
    {
      "slot": 2,
      "type": {"name": "poison", "url": "https://pokeapi.co/api/v2/type/4/"}
    }
  ],
  "weight": 69,
  'sprites': {
    "other": {
      "official-artwork": {
        "front_default":
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
      }
    }
  }
};

Pokemon pokemon = Pokemon(
    id: 1,
    name: 'bulbasaur',
    height: 10,
    weight: 10,
    imageUrl: 'imageUrl',
    types: [],
    stats: [],
    isFavorite: false);

