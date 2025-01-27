import 'package:flutter/material.dart';

import 'package:mobile_app/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: CustomColors.primary,
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
