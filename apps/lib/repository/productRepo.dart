import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/product.dart';
import 'package:top_ups/model/gamePass.dart';
import 'package:top_ups/model/VoucherModel.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  /// Mengambil data produk berdasarkan kategori dan gameType dari Firebase Realtime Database
  Future<List<BaseProduct>> fetchProducts(
      String category, String gameType) async {
    print("🔍 Fetching products for category: $category, gameType: $gameType");

    final snapshot = await _db.child("$category/$gameType").get();

    if (!snapshot.exists || snapshot.value == null) {
      print("⚠️ No data found at path: $category/$gameType");
      return [];
    }

    print("📦 Raw Snapshot Data: ${snapshot.value}");

    try {
      // Konversi data dari Firebase
      final rawData = snapshot.value as Map<dynamic, dynamic>;
      final data = rawData.map((key, value) =>
          MapEntry(key.toString(), value as Map<dynamic, dynamic>));

      print("✅ Converted Data: $data");

      List<BaseProduct> products = [];

      data.forEach((id, value) {
        final jsonData = value.map((key, val) => MapEntry(key.toString(), val));

        if (category == "Non_Games") {
          products.add(VoucherModel.fromJson(id, gameType, jsonData));
        } else if (category == "Games") {
          if (gameType == "pass") {
            products.add(GamePassModel.fromJson(id, jsonData));
          } else {
            jsonData.forEach((subId, value) {
              print(
                  "🛠️ Parsing Sub-ID: $subId dengan Value: $value (${value.runtimeType})");
              // Konversi jika tipe bukan Map<String, dynamic>
              if (value is String) {
                try {
                  value = jsonDecode(value);
                } catch (e) {
                  return;
                }
              }

              if (value is List && value.isNotEmpty) {
                value = value.first;
              }

              // Konversi Map<Object?, Object?> ke Map<String, dynamic>
              if (value is Map<Object?, Object?>) {
                value = Map<String, dynamic>.from(value);
                print(
                    "🔄 Converted _Map<Object?, Object?> to Map<String, dynamic>: $value");
              }
              var product = GameCurrencyModel.fromJson(subId, value);
              products.add(product);
            });
          }
        }
      });

      return products;
    } catch (e, stack) {
      return [];
    }
  }
}
