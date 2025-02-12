import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/pages/home.dart';
import 'package:getwidget/getwidget.dart';
import 'package:top_ups/provider/baseProvider.dart';
import 'package:top_ups/ui/homeBase/game/gameDetail.dart';

class HomeGame extends ConsumerWidget {
  static const routeName = homeMenu.routeName + "/homeGame";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Game List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: gamesAsync.when(
          data: (games) => GridView.builder(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return GestureDetector(
                onTap: () {
                  ref.read(selectedGameProvider.notifier).state = game.name;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailPage(gameName: game.name),
                    ),
                  );
                },
                child: GFCard(
                  boxFit: BoxFit.cover,
                  titlePosition: GFPosition.start,
                  showOverlayImage: true,
                  imageOverlay: game.imgUrl.startsWith('http') ||
                          game.imgUrl.startsWith('https')
                      ? NetworkImage(game.imgUrl) as ImageProvider
                      : AssetImage("${game.imgUrl}"),
                  title: GFListTile(
                    title: Text(
                      game.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  content: Center(
                    child: Text(
                      game.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text("Error: $error")),
        ),
      ),
    );
  }
}
