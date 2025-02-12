import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:top_ups/ui/homeBase/game/game.dart';
import 'package:top_ups/ui/homeBase/non-game/voucher.dart';

final indexBottomNavbarProvider = StateProvider<int>((ref) => 0);

class homeMenu extends ConsumerWidget {
  const homeMenu({super.key});
  static const routeName = '/homeMenu';

  Widget build(BuildContext context, WidgetRef ref) {
    final indexBottomNavbar =
        ref.watch(indexBottomNavbarProvider); // Tetap gunakan ini

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          ref.read(indexBottomNavbarProvider.notifier).state = value;
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Voucher'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Entertaiment'),
        ],
        currentIndex: indexBottomNavbar,
      ),
      body: IndexedStack(
        index: indexBottomNavbar,
        children: [
          HomeGame(),
          VoucherHome(category: "Non_Games", voucherType: "Voucher"),
          const Center(child: Text('Hello From Profile Screen')),
        ],
      ),
    );
  }
}
