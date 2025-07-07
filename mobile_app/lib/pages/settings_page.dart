import 'package:flutter/material.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/navbar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres", style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: CustomColors.dark_accent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          ListTile(
            style: ListTileStyle.drawer,
            leading: Icon(Icons.text_increase),
            title: Text("Taille du texte"),
            onTap: () {
              // À implémenter
            },
          ),
          SizedBox(height: 30),
          ListTile(
            style: ListTileStyle.drawer,
            leading: Icon(Icons.volume_up),
            title: Text("Activer l’assistance vocale"),
            onTap: () {
              // À implémenter
            },
          ),
          SizedBox(height: 30),
          ListTile(
            style: ListTileStyle.drawer,
            leading: Icon(Icons.lock),
            title: Text("Confidentialité"),
            onTap: () {
              // À implémenter
            },
          ),
              ],
            ),
          ),
        ],
        
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(Icons.logout, size: 20),
            label: Text("Se déconnecter", style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.orangeAccent,
              foregroundColor: Colors.black,
              
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            onPressed: () {
              CachingStorageService().clearCache().then((_) {
                Navigator.pushReplacementNamed(context, '/login');
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur lors de la déconnexion : $error")),
                );
              });
            },
          ),
        ),
      ),

    bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(10.0),
        child: CustomNavbar()
      )
    );
  }
}
