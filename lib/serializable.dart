library serializable;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class Serializable {
  late bool _serializableCompressionEnabled;

  /// Create a new serializable object, if [serializableCompressionEnabled] is true the serialized data will be compressed with gzip.
  /// <br><br><i> Note: for small and simple objects, it is recommended to let compression disabled </i>
  Serializable({bool serializableCompressionEnabled = false}) {
    _serializableCompressionEnabled = serializableCompressionEnabled;
  }

  /// Serialize the object to a list of bytes.
  /// The serialization is done in a separate isolate.
  /// 1. Convert the object to a map
  /// 2. Convert the map to a list of bytes
  /// 3. Compress the list of bytes (if compression is enabled)
  /// 4. Return the compressed list of bytes
  Future<List<int>> serialize() async {
    return await compute(_serializeInIsolate, toJson());
  }

  Future<Uint8List> serializeToUint8List() async {
    return Uint8List.fromList(await serialize());
  }

  List<int> _serializeInIsolate(Map data) {
    final String encodedJson = json.encode(data);
    final Uint8List bytes = utf8.encode(encodedJson);
    return _serializableCompressionEnabled ? gzip.encode(bytes) : bytes;
  }

  /// Deserialize the object from a list of bytes.
  /// The deserialization is done in a separate isolate.
  /// 1. Decompress the list of bytes (if compression is enabled)
  /// 2. Convert the decompressed bytes to a map
  /// 3. Convert the map to data for itself
  Future<void> deserialize(List<int> bytes) async {
    fromJson(await compute(_deserializeInIsolate, bytes));
  }

  Future<void> deserializeFromUint8List(Uint8List bytes) async {
    await deserialize(bytes.toList());
  }

  Map<String, dynamic> _deserializeInIsolate(List<int> bytes) {
    final List<int> serialized =
        _serializableCompressionEnabled ? gzip.decode(bytes) : bytes;
    final String encodedJson = utf8.decode(serialized);
    return json.decode(encodedJson);
  }

  Map<String, dynamic> toJson();
  fromJson(Map<String, dynamic> map);
}
