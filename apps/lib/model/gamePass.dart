import 'package:top_ups/model/product.dart';

class GamePassModel extends BaseProduct {
  final String description;

  GamePassModel({
    required super.id,
    required super.name,
    required super.price,
    required this.description,
  });

  factory GamePassModel.fromJson(String id, Map<String, dynamic> json) {
    return GamePassModel(
      id: id,
      name: json['name'],
      price: json['price'],
      description: json['description'] ?? '',
    );
  }
}
