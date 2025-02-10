import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/pages/home.dart';
import 'package:getwidget/getwidget.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:top_ups/ui/homeBase/gameDetail.dart';

class HomeGame extends ConsumerWidget {
  static const routeName = homeMenu.routeName + "/homeGame";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> games = ["HoK", "Genshin Impact"];

    return Scaffold(
      appBar: AppBar(title: Text("Game List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          shrinkWrap: true, // Menghindari overflow
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8, // Menyesuaikan tinggi kartu
            crossAxisSpacing: 8, // Menambahkan jarak antar kartu
            mainAxisSpacing: 8, // Menambahkan jarak antar kartu
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ref.read(selectedGameProvider.notifier).state = games[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GameDetailPage(gameName: games[index]),
                  ),
                );
              },
              child: GFCard(
                boxFit: BoxFit.cover,
                titlePosition: GFPosition.start,
                showOverlayImage: true,
                imageOverlay: AssetImage('assets/images/game_placeholder.png'),
                title: GFListTile(
                  avatar: GFAvatar(
                    backgroundColor: GFColors.PRIMARY,
                    child: Icon(Icons.videogame_asset, color: Colors.white),
                  ),
                  title: Text(
                    games[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1, // Membatasi teks ke 1 baris
                    overflow: TextOverflow.ellipsis, // Memotong teks panjang
                  ),
                ),
                content: Center(
                  child: Text(
                    games[index],
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
