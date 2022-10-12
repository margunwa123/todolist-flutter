import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../Archived/archived_screen.dart';
import '../Favorited/favorites_screen.dart';

class ListAppbar extends StatefulWidget implements PreferredSizeWidget {
  const ListAppbar({super.key}): preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  State<StatefulWidget> createState() => _ListAppBarState();
}

class _ListAppBarState extends State<ListAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: const Text("Todo App"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FavoriteScreen()));
                },
                icon: const Icon(Icons.favorite)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ArchivedScreen()));
                },
                icon: const Icon(Icons.archive)),
            IconButton(
              onPressed: () {
                final theme = AdaptiveTheme.of(context);
                if(theme.mode == AdaptiveThemeMode.dark) {
                  AdaptiveTheme.of(context).setLight();
                }
                else {
                  AdaptiveTheme.of(context).setDark();
                }
              }, 
              icon: const Icon(Icons.dark_mode)
            )
          ],
        );
  }
  
}