import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_app/Archived/archived_screen.dart';
import 'package:todo_app/List/list_screen.dart';
import 'package:todo_app/Favorited/favorites_screen.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: const Align(
              alignment: Alignment.bottomRight,
              child: Text("Todolist app",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24
              ),)),
        ),
        Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Todos"),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ListScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoriteScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Archived"),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ArchivedScreen())),
            )
          ],
        )),
      ],
    ));
  }
}
