import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/model/product.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/gamePass.dart';
import 'package:top_ups/model/VoucherModel.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:intl/intl.dart';
import 'package:top_ups/services/midtrans.dart';
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
    final selectedPayment = ref.watch(selectedPaymentProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Top-Up ${widget.gameName}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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

                return PopupMenuButton<BaseProduct>(
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
                            "${product.name} - ${formatCurrency(totalPrice)} (Termasuk Pajak)"),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            _buildPaymentMethods(context, selectedPayment),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (selectedProduct == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Silakan pilih nominal top-up")),
                  );
                  return;
                }

                String orderId = GenerateOrderID();
                int grossAmount = (selectedProduct!.price * 1.1).round();
                String itemId = selectedProduct!.id.toString();
                String itemName = selectedProduct!.name;
                int price = selectedProduct!.price;

                String? snapToken = await MidtransService.getSnapToken(
                  orderId: orderId,
                  email: emailController.text,
                  itemId: itemId,
                  itemName: itemName,
                  price: price,
                );

                if (snapToken != null) {
                  await MidtransService.startPayment(snapToken);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal mendapatkan Snap Token")),
                  );
                }
              },
              child:
                  Text("Bayar", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods(BuildContext context, String? selectedPayment) {
    return Column(
      children: [
        _buildSelectableTile(context, "QRIS", Icons.qr_code, selectedPayment),
        ExpansionTile(
          leading: Icon(Icons.account_balance),
          title: Text("Bank"),
          children: [
            _buildSelectableTile(
                context, "BCA", Icons.account_balance, selectedPayment),
            _buildSelectableTile(
                context, "BRI", Icons.account_balance, selectedPayment),
            _buildSelectableTile(
                context, "BNI", Icons.account_balance, selectedPayment),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("E-Wallet"),
          children: [
            _buildSelectableTile(context, "ShopeePay",
                Icons.account_balance_wallet, selectedPayment),
            _buildSelectableTile(
                context, "OVO", Icons.account_balance_wallet, selectedPayment),
          ],
        ),
        _buildSelectableTile(
            context, "Convenience Store", Icons.store, selectedPayment),
      ],
    );
  }

  Widget _buildSelectableTile(BuildContext context, String method,
      IconData icon, String? selectedPayment) {
    return ListTile(
      leading: Icon(icon),
      title: Text(method),
      selected: selectedPayment == method,
      selectedTileColor: Colors.blue[100],
      onTap: () {
        ref.read(selectedPaymentProvider.notifier).state = method;
      },
    );
  }
}

String formatCurrency(int price) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  return formatter.format(price);
}

String GenerateOrderID() {
  return "ORDER" +
      DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
}
