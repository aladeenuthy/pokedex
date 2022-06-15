import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}
