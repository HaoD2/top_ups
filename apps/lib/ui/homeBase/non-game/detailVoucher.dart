import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailVoucher extends ConsumerStatefulWidget {
  final String voucherName;
  DetailVoucher({required this.voucherName});

  @override
  _DetailVoucherState createState() => _DetailVoucherState();
}

class _DetailVoucherState extends ConsumerState<DetailVoucher> {
  late final Map<String, String> params;

  @override
  void dispose() {
    // Reset pilihan game saat keluar dari halaman ini
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top-Up ${widget.voucherName}")),
    );
  }
}
