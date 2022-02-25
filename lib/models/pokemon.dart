class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> types;
  final List<Stat> stats;
  bool isFavorite;
  Pokemon({required this.id,required this.name, required this.height, required this.weight, required this.imageUrl, required this.types, required this.stats, required this.isFavorite});
}

class Stat {
  final String name;
  final int baseStat;
  Stat({required this.name, required this.baseStat});
}
