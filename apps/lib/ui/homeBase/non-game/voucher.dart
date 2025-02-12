import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:top_ups/pages/home.dart';
import 'package:top_ups/provider/baseProvider.dart';

class VoucherHome extends ConsumerWidget {
  final String category;
  final String voucherType;
  const VoucherHome({
    super.key,
    required this.category,
    required this.voucherType,
  });
  static const routeName = homeMenu.routeName + "/homeVoucher";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchers = ref.watch(voucherProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Voucher List')),
      body: vouchers.when(
        data: (voucherList) {
          if (voucherList.isEmpty) {
            return const Center(child: Text('No vouchers available.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: voucherList.length, // ✅ Gunakan voucherList
            itemBuilder: (context, index) {
              final voucher =
                  voucherList[index]; // ✅ Akses langsung dari voucherList

              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${voucher.name}')),
                  );
                },
                child: GFCard(
                  boxFit: BoxFit.cover,
                  titlePosition: GFPosition.start,
                  showOverlayImage: true,
                  imageOverlay: const AssetImage('assets/images/voucher.png'),
                  title: GFListTile(
                    title: Text(
                      voucher.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  content: Center(
                    child: Text(
                      voucher.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
