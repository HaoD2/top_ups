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
  final Map<String, List<String>> _voucherCache = {};
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
      final rawData = snapshot.value as Map<dynamic, dynamic>;

      // Debug untuk melihat tipe data setiap key
      rawData.forEach((key, value) {
        print("🔍 Key: $key | Type: ${value.runtimeType} | Value: $value");
      });

      // Filter hanya data bertipe Map
      final data = Map.fromEntries(
        rawData.entries.where((entry) => entry.value is Map).map((entry) =>
            MapEntry(
                entry.key.toString(), entry.value as Map<dynamic, dynamic>)),
      );

      print("✅ Filtered Data: $data");

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
              print("🛠️ Parsing Sub-ID: $subId dengan Value: $value");

              if (value == null) {
                print("❌ SKIPPED: $subId karena value == null");
                return;
              }

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

              if (value is Map) {
                try {
                  value = Map<String, dynamic>.from(
                      value.map((k, v) => MapEntry(k.toString(), v)));
                  print("🔄 Converted Value: ${jsonEncode(value)}");
                } catch (e) {
                  print("❌ Error converting value: $e");
                  return;
                }
              }

              if (value is! Map<String, dynamic> || value.isEmpty) {
                print("❌ SKIPPED: $subId karena value tidak valid");
                return;
              }

              var product = GameCurrencyModel.fromJson(subId, value);
              products.add(product);
              print("✅ Added Product: ${product.toString()}");
            });
          }
        }
      });

      return products;
    } catch (e) {
      print("❌ Error: $e");
      return [];
    }
  }

  Future<List<GameModel>> fetchGames() async {
    print("🔍 Fetching games from database");

    final snapshot = await _db.child("Games").get();

    if (!snapshot.exists || snapshot.value == null) {
      print("⚠️ No games found in database");
      return [];
    }

    try {
      final rawData = Map<String, dynamic>.from(
          snapshot.value as Map); // Konversi ke Map<String, dynamic>

      final gameList = rawData.entries.map((entry) {
        final name = entry.key; // Nama game sebagai key
        final data =
            Map<String, dynamic>.from(entry.value as Map); // Konversi nilai map
        return GameModel.fromJson(name, data);
      }).toList();

      print("✅ Fetched games: $gameList");
      return gameList;
    } catch (e) {
      print("❌ Error fetching games: $e");
      return [];
    }
  }

  Future<List<VoucherModel>> fetchVoucher() async {
    print("🔍 Fetching vouchers from Non_Games/Voucher");

    final snapshot = await _db.child("Non_Games/Voucher").get();

    if (!snapshot.exists || snapshot.value == null) {
      print("⚠️ No vouchers found in database");
      return [];
    }

    try {
      final rawData = Map<String, dynamic>.from(snapshot.value as Map);
      print("🗂 Raw data: $rawData");

      final voucherList = rawData.entries.map((entry) {
        final vendorName = entry.key; // Ambil nama vendor seperti "Steam"
        return VoucherModel(
          id: vendorName,
          name: vendorName, // Gunakan vendorName sebagai nama voucher
          price: 0, // Kosongkan harga karena tidak perlu
          vendor: vendorName,
        );
      }).toList();

      print("✅ Fetched vouchers: $voucherList");
      return voucherList;
    } catch (e) {
      print("❌ Error fetching vouchers: $e");
      return [];
    }
  }
}
