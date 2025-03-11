import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';

class MidtransService {
  static MidtransSDK? _midtrans;

  /// Inisialisasi Midtrans SDK
  static Future<void> init() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey:
            'SB-Mid-client-m84fnczsDGTvZck9', // Ganti dengan Client Key Midtrans
        merchantBaseUrl:
            'https://famous-mastiff-sunny.ngrok-free.app', // API Backend kamu
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print("Transaksi Selesai: ${result.toJson()}");
    });
  }

  /// Ambil Snap Token dari Backend
  static Future<String?> getSnapToken({
    required String orderId,
    required String email,
    required String itemId,
    required String itemName,
    required int price,
  }) async {
    try {
      final url = Uri.parse(
          'https://famous-mastiff-sunny.ngrok-free.app/api/payment/Snap/purchase');

      // Hitung gross_amount dari item_details
      int grossAmount = price; // Pastikan tidak ada selisih dengan harga item

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "transaction_detail": {
            "order_id": orderId,
            "gross_amount":
                grossAmount, // Pastikan sesuai dengan jumlah item_details
          },
          "customer_detail": {
            "user": email,
          },
          "item_details": [
            // Item harus dalam array
            {
              "id": itemId,
              "item_game": itemName,
              "price": price,
              "quantity": 1 // Pastikan ada jumlahnya
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Kembalikan Snap Token
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  /// Jalankan UI Pembayaran dengan Snap Token
  static Future<void> startPayment(String snapToken) async {
    if (_midtrans == null) {
      await init(); // Pastikan SDK terinisialisasi sebelum digunakan
    }
    await _midtrans?.startPaymentUiFlow(
      token: snapToken,
    );
  }
}
