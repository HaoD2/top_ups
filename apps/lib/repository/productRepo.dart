import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/gameModel.dart';
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

              if (value == null) {
                print("❌ SKIPPED: $subId karena value == null");
                return;
              }

              // Konversi jika tipe bukan Map<String, dynamic>
              if (value is String) {
                try {
                  value = jsonDecode(value);
                  print("🔄 Converted String to Map: $value");
                } catch (e) {
                  print("❌ Failed to parse JSON: $value");
                  return;
                }
              }

              if (value is List && value.isNotEmpty) {
                value = value.first;
                print("🔄 Converted List to Map: $value");
              }

              // Konversi Map<Object?, Object?> ke Map<String, dynamic>
              if (value is Map<Object?, Object?>) {
                value = Map<String, dynamic>.from(value);
                print(
                    "🔄 Converted _Map<Object?, Object?> to Map<String, dynamic>: $value");
              }

              if (value is! Map<String, dynamic>) {
                print(
                    "❌ SKIPPED: $subId karena value masih bukan Map<String, dynamic> (Tipe: ${value.runtimeType})");
                return;
              }

              if (value.isEmpty) {
                print("❌ SKIPPED: $subId karena value kosong");
                return;
              }

              var product = GameCurrencyModel.fromJson(subId, value);
              products.add(product);
              print(
                  "✅ Added Product: ${product.id}, Price: ${product.price}, Amount: ${product.amount}, Bonus: ${product.bonus}");
            });
          }
        }
      });

      return products;
    } catch (e, stack) {
      return [];
    }
  }

  Future<List<String>> fetchGames() async {
    print("🔍 Fetching game types from database");

    final snapshot = await _db.child("Games").get();

    if (!snapshot.exists || snapshot.value == null) {
      print("⚠️ No game types found in database");
      return [];
    }

    try {
      final rawData = snapshot.value as Map<dynamic, dynamic>;
      final gameList = rawData.keys.map((key) => key.toString()).toList();

      print("✅ Fetched game types: $gameList");
      return gameList;
    } catch (e) {
      print("❌ Error fetching game types: $e");
      return [];
    }
  }
}
