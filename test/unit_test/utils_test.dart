import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/utils/utilities.dart';

void main() {
  test('turn list to string and remove the brackets', () {
    var testList = ['type', 'types'];
    final value = removeBrackets(testList.toString());
    expect(value, 'type, types');
  });

  test('return different color for diffeerent percentages', () {
    expect(getColor(0.24), Colors.red);
    expect(getColor(0.4), Colors.orange);
    expect(getColor(0.7), Colors.yellow);
    expect(getColor(0.9), Colors.green);
  });

  test('palette generator test', () async {
    
  });
}
