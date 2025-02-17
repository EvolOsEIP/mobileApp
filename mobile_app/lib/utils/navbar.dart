import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class CustomNavbar extends StatelessWidget {
  final String profileImageUrl;

  const CustomNavbar({super.key, required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double navbarHeight = screenWidth * 0.10; // 5% de la largeur
    double iconSize = screenWidth * 0.07; // 8% de la largeur
    double avatarSize = screenWidth * 0.07; // 12% de la largeur

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            navbarHeight * 0.5), // Arrondi en fonction de la hauteur
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Ombre légère
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement égal
        children: [
          // Image de profil responsive
          ClipRRect(
            borderRadius:
                BorderRadius.circular(avatarSize * 0.5), // Cercle parfait
            child: Image.network(
              profileImageUrl,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
            ),
          ),
          // Icône centrale (livre)
          IconButton(
            icon: Icon(Icons.menu_book,
                color: CustomColors.dark_accent, size: iconSize),
            onPressed: () {
              // Action bouton du centre
            },
          ),
          // Icône étoile
          IconButton(
            icon: Icon(Icons.star_border,
                color: CustomColors.dark_accent, size: iconSize),
            onPressed: () {
              // Action bouton de droite
            },
          ),
        ],
      ),
    );
  }
}
