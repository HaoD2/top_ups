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
  late final Future<List<BaseProduct>> futureProducts;
  BaseProduct? selectedProduct;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final params = {'category': 'Games', 'gameType': widget.gameName};
    futureProducts = ref.read(productsProvider(params).future);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top-Up ${widget.gameName}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<BaseProduct>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(child: Text("Tidak ada data tersedia"));
                }

                return SingleChildScrollView(
                  child: PopupMenuButton<BaseProduct>(
                    onSelected: (BaseProduct value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                    itemBuilder: (context) {
                      return snapshot.data!.map((product) {
                        int totalPrice =
                            (product.price * 1.1).round(); // Pajak 10%
                        return PopupMenuItem<BaseProduct>(
                          value: product,
                          child: Text(
                            "${product.name} - ${formatCurrency(totalPrice)} (Termasuk Pajak)",
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedProduct != null
                              ? "${selectedProduct!.name} - ${formatCurrency((selectedProduct!.price * 1.1).round())}"
                              : "Pilih nominal top-up"),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Nomor Telepon"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),
            Text("Pilih Metode Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildPaymentMethods(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        Card(
            child: ListTile(leading: Icon(Icons.qr_code), title: Text("QRIS"))),
        Card(
            child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text("E-Wallet"))),
        Card(
            child: ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Virtual Account"))),
        Card(
            child: ListTile(
                leading: Icon(Icons.store), title: Text("Convenience Store"))),
      ],
    );
  }

  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(price);
  }
}
