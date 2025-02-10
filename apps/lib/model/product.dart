import 'package:top_ups/model/VoucherModel.dart';
import 'package:top_ups/model/gameCurrency.dart';
import 'package:top_ups/model/gamePass.dart';
import 'package:flutter/foundation.dart';

abstract class BaseProduct {
  final String id;
  final String name;
  final int price;

  BaseProduct({
    required this.id,
    required this.name,
    required this.price,
  });
}
