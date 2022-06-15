import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/providers/pokemons.dart';
import 'package:pokedex/screens/mobile_screen.dart';
import 'package:pokedex/screens/pokemon_details_screen.dart';
import 'package:pokedex/widgets/all_pokemons.dart';
import 'package:pokedex/widgets/badge.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';
import '../mocks/mocks.dart';
import '../unit_test/data.dart';

void main() {
  late MockDio mockDio;
  late MockSharedPreferences mockPref;
  setUp(() {
    mockDio = MockDio();
    mockPref = MockSharedPreferences();
  });
  Widget buildWidget() {
    return ChangeNotifierProvider(
      create: (_) => Pokemons(mockDio, mockPref),
      child: const MaterialApp(
          title: 'Pokedex',
          debugShowCheckedModeBanner: false,
          home: MobileScreen()),
    );
  }

  void arrangeGetPokemonsAndGetPokemonObjResponse(
      [bool with1SecondDelay = false]) {
    when(() => mockDio.get('https://pokeapi.co/api/v2/pokemon?limit=11'))
        .thenAnswer((_) async {
      if (with1SecondDelay) {
        await Future.delayed(const Duration(seconds: 1));
      }
      return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: pokemonResponse);
    });
    when(() => mockDio.get("https://pokeapi.co/api/v2/pokemon/1/"))
        .thenAnswer((_) async {
      if (with1SecondDelay) {
        await Future.delayed(const Duration(seconds: 1));
      }
      return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: pokemonData);
    });
  }
  // set color in pokemon card and pokemon details screeen to null!!!!
  testWidgets(
      "circular progress indicator runs at first ,then pokemon is returned and displayed, then circular progress indicator dissapears",
      (tester) async {
    // set color in pokemon card to nulll
    arrangeGetPokemonsAndGetPokemonObjResponse(true);
    await tester.pumpWidget(buildWidget());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(pokemonData['name']), findsOneWidget);
    expect(find.byType(PokemonCard), findsOneWidget);
  });

  testWidgets("pokemon returned is a favorite pokemon hence finds badge widget",
      (tester) async {
    arrangeGetPokemonsAndGetPokemonObjResponse();
    when(() => mockPref.getStringList('favorites'))
        .thenReturn([pokemonData['name']]);
    await tester.pumpWidget(buildWidget());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(Badge), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets("tapping pokemon opens pokemon details screen", (tester) async {
    arrangeGetPokemonsAndGetPokemonObjResponse();
    when(() => mockPref.getStringList('favorites'))
        .thenReturn([pokemonData['name']]);
    await tester.pumpWidget(buildWidget());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text(pokemonData['name']));
    await tester.pumpAndSettle();
    expect(find.byType(AllPokemons), findsNothing);
    expect(find.byType(PokemonDetailsScreen), findsOneWidget);
  });
}
