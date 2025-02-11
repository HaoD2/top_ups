import 'package:top_ups/model/product.dart';

class GameModel extends BaseProduct {
  final String imgUrl;

  GameModel({
    required super.id,
    required super.name,
    required super.price,
    required this.imgUrl,
  });

  factory GameModel.fromJson(String id, Map<String, dynamic> json) {
    return GameModel(
      id: id,
      name: json['name'] ?? id,
      price: json['price'] ?? 0,
      imgUrl: json['img_url'] ?? '',
    );
  }
}
