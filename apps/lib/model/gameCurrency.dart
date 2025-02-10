import 'package:top_ups/model/product.dart';

// Model untuk Currency dalam game (contoh: Genesis Crystals atau HoK Tokens)
class GameCurrencyModel extends BaseProduct {
  final int amount;
  final int bonus;

  GameCurrencyModel({
    required String id,
    required String name,
    required int price,
    required this.amount,
    required this.bonus,
  }) : super(id: id, name: name, price: price);

  factory GameCurrencyModel.fromJson(String id, Map<String, dynamic> json) {
    print(
        "🔍 Creating GameCurrencyModel: ID=$id, JSON=$json"); // Tambahkan debug log
    return GameCurrencyModel(
      id: id,
      name: id, // Jika `name` tidak ada, gunakan ID
      price: json['price'] ?? 0,
      amount: json['amount'] ?? 0,
      bonus: json['bonus'] ?? 0,
    );
  }

  @override
  String toString() {
    return "GameCurrencyModel(id: $id, name: $name, price: $price, amount: $amount, bonus: $bonus)";
  }
}
