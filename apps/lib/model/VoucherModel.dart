import 'package:top_ups/model/product.dart';

class VoucherModel extends BaseProduct {
  final String vendor;

  VoucherModel({
    required super.id,
    required super.name,
    required super.price,
    required this.vendor,
  });

  factory VoucherModel.fromJson(
      String id, String vendor, Map<String, dynamic> json) {
    return VoucherModel(
      id: id,
      name: json['name'],
      price: json['price'],
      vendor: vendor,
    );
  }
}
