// import 'package:flutter/material.dart';
// import 'package:mobile_app/utils/colors.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 1;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: CustomColors.dark_accent,
//         title: const Text(
//           'Accueil',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 20.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildCard(
//                     title: 'Profile',
//                     icon: Icons.person,
//                     onTap: () {
//                       print("Profile");
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: _buildCard(
//                     title: 'Voir ma progression',
//                     icon: Icons.bar_chart,
//                     onTap: () {
//                       print("Voir ma progression");
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20.0),
//             _buildCard(
//               title: 'Voir la liste des modules',
//               icon: Icons.list,
//               onTap: () {
//                 Navigator.pushNamed(context, '/units');
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: CustomColors.dark_accent,
//         selectedItemColor: CustomColors.accent,
//         unselectedItemColor: Colors.white,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Stats'),
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   Widget _buildCard({required String title, required IconData icon, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 5,
//         color: Colors.white,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: CustomColors.dark_accent),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.dark_accent,
        title: const Text(
          'Accueil',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      print("Profile");
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildCard(
                    title: 'Voir ma progression',
                    icon: Icons.bar_chart,
                    onTap: () {
                      print("Voir ma progression");
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildCard(
              title: 'Voir la liste des modules',
              icon: Icons.list,
              onTap: () {
                Navigator.pushNamed(context, '/units');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.dark_accent,
        selectedItemColor: CustomColors.accent,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.query_stats), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: CustomColors.dark_accent),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
