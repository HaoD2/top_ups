import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:top_ups/ui/homeBase/game.dart';

class homeMenu extends ConsumerWidget {
  const homeMenu({super.key});
  static const routeName = '/homeMenu';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodies = [
      HomeGame(),
      const Center(
        child: Text('Hello From Voucher'),
      ),
      const Center(
        child: Text('Hello From Profile Screen'),
      ),
    ];
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
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
      body: bodies[indexBottomNavbar],
    );
  }
}
