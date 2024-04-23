// // lib/features/community/screens/home.dart
// import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:byte_app/features/community/screens/post.dart';
// import 'package:byte_app/features/community/screens/feed.dart'; // Create and import this
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   int selectedIndex = 0;
//   final PanelController panelController = PanelController();
//
//   // Placeholder Widgets for other screens
//   final Widget feedScreenPlaceholder = Center(child: Text('Feed Screen Placeholder'));
//   final Widget searchScreen = Center(child: Text('Search Screen'));
//   final Widget favoriteScreen = Center(child: Text('Favorite Screen'));
//   final Widget profileScreen = Center(child: Text('Profile Screen'));
//
//   late List<Widget> pages;
//
//   @override
//   void initState() {
//     super.initState();
//     pages = [
//       FeedScreen(),
//       searchScreen, // Replace with actual screen when available
//       PostScreen(panelController: panelController),
//       favoriteScreen, // Replace with actual screen when available
//       profileScreen, // Replace with actual screen when available
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SlidingUpPanel(
//         controller: panelController,
//         minHeight: 0,
//         maxHeight: MediaQuery.of(context).size.height * 0.8,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//         panelBuilder: (ScrollController sc) => PostScreen(panelController: panelController),
//         body: pages[selectedIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         onTap: (index) {
//           if (index == 2) {
//             panelController.isPanelOpen ? panelController.close() : panelController.open();
//           } else {
//             setState(() {
//               selectedIndex = index;
//               if (panelController.isPanelOpen) {
//                 panelController.close();
//               }
//             });
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }