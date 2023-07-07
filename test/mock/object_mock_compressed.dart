import 'package:serializable/serializable.dart';

class ObjectMockCompressed extends Serializable {
  String name = '';
  int age = 0;

  ObjectMockCompressed({required this.name, required this.age})
      : super(serializableCompressionEnabled: true);

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
