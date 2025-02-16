# Serializable

Serializable is a Dart package that provides a way to serialize and deserialize objects. It supports optional gzip compression and performs serialization asynchronously in an Isolate.

## Usage
```dart
class Object extends Serializable {
  String name = '';
  int age = 0;

  Object({required this.name, required this.age});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> map) {
    name = map['name'];
    age = map['age'];
  }
}
```
`toJson` and `fromJson` methods must be overridden in the class that extends `Serializable`. If a field is not required (Transient) just don't include it in the `toJson` method and `fromJson` will not set it.
