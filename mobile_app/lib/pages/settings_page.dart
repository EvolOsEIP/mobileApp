import 'package:flutter/material.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'package:mobile_app/utils/navbar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.text_increase),
            title: Text("Taille du texte"),
            onTap: () {
              // À implémenter
            },
          ),
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text("Activer l’assistance vocale"),
            onTap: () {
              // À implémenter
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Confidentialité"),
            onTap: () {
              // À implémenter
            },
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: Text("Se déconnecter"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
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
