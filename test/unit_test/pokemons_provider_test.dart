import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:mocktail/mocktail.dart";
import 'package:pokedex/providers/pokemons.dart';
import 'data.dart';
import '../mocks/mocks.dart';

void main() {
  late Pokemons sut;
  late MockDio mockDio;
  late MockSharedPreferences mockPref;
  setUp(() {
    mockDio = MockDio();
    mockPref = MockSharedPreferences();
    sut = Pokemons(mockDio, mockPref);
  });

  void arrangeGetPokemonsAndGetPokemonObjResponse() {
    when(() => mockDio.get('https://pokeapi.co/api/v2/pokemon?limit=11'))
        .thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: pokemonResponse));
    when(() => mockDio.get("https://pokeapi.co/api/v2/pokemon/1/")).thenAnswer(
        (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: pokemonData));
  }

  test("getPokemonObj return null when error occurs", () async {
    //arrange
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ));
    //act
    final pokemon = await sut.getPokemonObj('url');
    //assert
    expect(pokemon, null);
  });

  test("getPokemonObj returns Pokemon object", () async {
    //arrange
    when(() => mockDio.get(any())).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: pokemonData));
    // act
    final pokemon = await sut.getPokemonObj('url');
    //assert
    expect(pokemon?.name, 'bulbasaur');
  });

  test("pokemon api unsuccessful and return null due to bad response from server ", () async {
    // arrange
    when(() => mockDio.get(any())).thenAnswer((_) async =>
        Response(requestOptions: RequestOptions(path: ''), statusCode: 400));
    // act
    final response = await sut.fetchFromApi();
    // assert
    expect(response, null);
  });

  test("pokemon api unsuccessful and return null due to bad internet connection", () async {
    // arrange
    when(() => mockDio.get(any())).thenAnswer(
        (_) async => throw const SocketException("no internet connection"));
    // act
    final response = await sut.fetchFromApi();
    // assert
    expect(response, null);
  });

  test(
      "pokemon api successful, _url gets set to next, pokemons list has one pokemon item, pokemon item is not added to provider favoriteList because it's not stored in SharedPreferences favoriteList",
      () async {
    // arrange
    arrangeGetPokemonsAndGetPokemonObjResponse();
    // act
    final message = await sut.fetchFromApi();

    //assert
    expect(sut.url, "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1");
    expect(sut.pokemons.length, 1);
    expect(sut.favoritiesLength, 0);
    expect(message, 'successful');
  });

  test(
      "pokemon api successful, _url gets set to next, pokemons list has one pokemon item, pokemon item is added to provider favoriteList because it's stored in SharedPreferences favoriteList",
      () async {
    // arrange
    arrangeGetPokemonsAndGetPokemonObjResponse();
    when(() => mockPref.getStringList('favorites'))
        .thenReturn([pokemonData['name']]);
    // act
    final message = await sut.fetchFromApi();

    //assert
    expect(sut.url, "https://pokeapi.co/api/v2/pokemon?offset=1&limit=1");
    expect(sut.pokemons.length, 1);
    expect(sut.favoritiesLength, 1);
    expect(message, 'successful');
  });

  test(
      "add to Provider favorite pokemon list , return Added to favorite list if because it is not favorited(not in sharedprefereces favorite list)",
      () async {
    // arrange
    when(() => mockPref.getStringList('favorites')).thenReturn(['pikachu']);
    when(() => mockPref.setStringList(any(), any()))
        .thenAnswer((_) async => true);
    // act
    final message = await sut.toggleFavorites(pokemon);

    //assert
    expect(sut.favoritiesLength, 1);
    expect(message, 'Added to favorite list');
  });

  test(
      "remove from Provider favorite pokemon list , return Added to favorite list if because it is not favorited(not in sharedprefereces favorite list)",
      () async {
    // arrange
    when(() => mockPref.getStringList('favorites'))
        .thenReturn(['pikachu', pokemonData['name']]);
    when(() => mockPref.setStringList(any(), any()))
        .thenAnswer((_) async => true);

    
    // act
    final message = await sut.toggleFavorites(pokemon);

    //assert
    expect(sut.favoritiesLength, 0);
    expect(message, 'Removed from favorite list');
  });
}
