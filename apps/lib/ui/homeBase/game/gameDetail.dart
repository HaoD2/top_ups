import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/model/product.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/gamePass.dart';
import 'package:top_ups/model/VoucherModel.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:intl/intl.dart';
import 'package:top_ups/ui/homeBase/game/game.dart';
import 'package:top_ups/provider/baseProvider.dart';

class GameDetailPage extends ConsumerStatefulWidget {
  final String gameName;

  GameDetailPage({required this.gameName});

  static String routeName(String gameName) => '${HomeGame.routeName}/$gameName';

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends ConsumerState<GameDetailPage> {
  static const routeName = HomeGame.routeName + '/game';
  late final Map<String, String> params;
  late final Future<List<BaseProduct>> futureProducts;
  @override
  void dispose() {
    // Reset pilihan game saat keluar dari halaman ini
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    params = {'category': 'Games', 'gameType': widget.gameName};
    futureProducts = ref.read(productsProvider(params).future);
    futureProducts.then((products) {
      print("Products fetched successfully: ${products.length}");
      for (var product in products) {
        print("Product: ${product.toString()}");
      }
    }).catchError((error, stackTrace) {
      print("Error fetching products: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top-Up ${widget.gameName}")),
      body: FutureBuilder<List<BaseProduct>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("❌ UI Error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("⚠️ No Data Available");
            return Center(child: Text("Tidak ada data tersedia"));
          }

          print("📌 UI is displaying ${snapshot.data!.length} items");

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              print("🛒 UI Displaying: ${item.toString()}");

              return ListTile(
                title: Text(item.name),
                subtitle: Text("Rp ${item.price}"),
                trailing: _buildTrailingWidget(item),
              );
            },
          );
        },
      ),
    );
  }

  /// Menampilkan informasi tambahan berdasarkan tipe produk
  Widget _buildTrailingWidget(BaseProduct item) {
    if (item is GameCurrencyModel) {
      return Text("${item.amount} + ${item.bonus} Bonus");
    } else if (item is GamePassModel) {
      return Text(item.description);
    } else if (item is VoucherModel) {
      return Text("Voucher ${item.vendor}");
    }
    return SizedBox.shrink();
  }

  /// Format harga ke mata uang Indonesia
  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(price);
  }
}
