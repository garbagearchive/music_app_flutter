import 'package:flutter/material.dart';
import 'package:music_app/pages/setting_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //Icon in drawer menu
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: ListTile(
              title: Text('HOME'),
              leading: Icon(Icons.home),
              onTap: () => Navigator.pop(
                context,
              ), //close drawer menu and go to home page
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: ListTile(
              title: Text('ADD PLAYLIST'),
              leading: Icon(Icons.playlist_add),
              onTap: () => {
                Navigator.pop(context), //same shit as above
                //redirect to setting page (setting_page.dart)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: ListTile(
              title: Text('SETTING'),
              leading: Icon(Icons.settings),
              onTap: () => {
                Navigator.pop(context), //same shit as above
                //redirect to setting page (setting_page.dart)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: ListTile(
              title: Text('ACCOUNT'),
              leading: Icon(Icons.contacts),
              onTap: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
