import 'package:flutter/material.dart';
import 'package:mobile_app/utils/fetchData.dart';
import 'package:mobile_app/services/dataCaching.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenService = CachingStorageService();
    tokenService.getFromCache('token').then((token) {
      if (token != null) {
        fetchFromApi('/auth/test', headers: {
          'Authorization': "Bearer $token"
        }).then((response) {
          if (!response.toString().contains('Exception')) {
            Navigator.pushReplacementNamed(context, '/roadmap');
          } else {
            tokenService.clearFromCache('token');
          }
        });
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Bienvenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Connecte-toi pour continuer',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Email invalide',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Mot de passe trop court',
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      postToApi('/auth/login', {
                        'email': emailController.text,
                        'password': passwordController.text
                      }, {}).then((response) async {
                        if (response != null && response.isNotEmpty) {
                          final token = response['token'];
                          final tokenService = CachingStorageService();
                          await tokenService.saveInCache(token, 'token');

                          fetchFromApi('/api/profile/me', headers: {
                            'Authorization': "Bearer $token"
                          }).then((profile) {
                            if (profile != null) {
                              tokenService.saveInCache(
                                  jsonEncode(profile), 'profile');
                              Navigator.pushReplacementNamed(
                                  context, '/roadmap');
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Email ou mot de passe incorrect.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: const Text('Se connecter'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("Pas encore de compte ? S'inscrire"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
