import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'mock/object_mock.dart';
import 'mock/object_mock_compressed.dart';

void main() {
  test('serialize', () async {
    final object = ObjectMock(name: 'John', age: 30);
    final bytes = await object.serialize();
    expect(bytes, isA<List<int>>());
  });

  test('deserialize', () async {
    final object = ObjectMock(name: 'John', age: 30);
    final bytes = await object.serialize();

    final object2 = ObjectMock(name: '', age: 0);
    await object2.deserialize(bytes);

    expect(object2.name, 'John');
    expect(object2.age, 30);
  });

  test('serializeToUint8List', () async {
    final object = ObjectMock(name: 'John', age: 30);
    final bytes = await object.serializeToUint8List();
    expect(bytes, isA<Uint8List>());
  });

  test('deserializeFromUint8List', () async {
    final object = ObjectMock(name: 'John', age: 30);
    final bytes = await object.serializeToUint8List();

    final object2 = ObjectMock(name: '', age: 0);
    await object2.deserializeFromUint8List(bytes);

    expect(object2.name, 'John');
    expect(object2.age, 30);
  });

  test('compression on small data, data size grows', () async {
    final object = ObjectMock(name: 'John', age: 30);
    final bytes = await object.serialize();

    final objectCompressed = ObjectMockCompressed(name: 'John', age: 30);
    final bytesCompressed = await objectCompressed.serialize();

    expect(bytesCompressed.length, greaterThan(bytes.length));
  });

  test('compression on big data, data size shrinks', () async {
    final objectBig = ObjectMock(
      name: 'John' * 1000,
      age: 30,
    );
    final bytesBig = await objectBig.serialize();

    final objectBigCompressed = ObjectMockCompressed(
      name: 'John' * 1000,
      age: 30,
    );
    final bytesBigCompressed = await objectBigCompressed.serialize();

    expect(bytesBigCompressed.length, lessThan(bytesBig.length));
  });
}
