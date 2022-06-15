class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> types;
  final List<Stat> stats;
  bool isFavorite;
  Pokemon(
      {required this.id,
      required this.name,
      required this.height,
      required this.weight,
      required this.imageUrl,
      required this.types,
      required this.stats,
      required this.isFavorite,
      });
  factory Pokemon.fromJson(Map<String, dynamic> json, bool isFavorite){
    List<Stat> stats = [];
    List<String> types = [];
    final List<Map<String, dynamic>> resStat = List<Map<String, dynamic>>.from(json['stats']);
    final List<Map<String, dynamic>> resTypes = List<Map<String, dynamic>>.from(json['types']);
    stats = resStat
        .map(
          (stat) =>
              Stat(name: stat['stat']['name'], baseStat: stat['base_stat']),
        )
        .toList();
    types = resTypes.map((type) => type['type']['name'] as String).toList();
    return Pokemon(
        id: json['id'],
        name: json['name'],
        height: json['height'],
        weight: json['weight'],
        imageUrl: json['sprites']['other']['official-artwork']
            ['front_default'],
        types: types,
        stats: stats,
        isFavorite: isFavorite);
  }
}

class Stat {
  final String name;
  final int baseStat;
  Stat({required this.name, required this.baseStat});
}


