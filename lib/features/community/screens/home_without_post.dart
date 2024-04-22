// lib/features/community/screens/home_without_post.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/screens/feed.dart'; // Import the Feed screen

class HomeWithoutPost extends StatefulWidget {
  const HomeWithoutPost({Key? key}) : super(key: key);

  @override
  _HomeWithoutPostState createState() => _HomeWithoutPostState();
}

class _HomeWithoutPostState extends State<HomeWithoutPost> {
  int selectedIndex = 0;

  // Placeholder Widgets for other screens
  final Widget feedScreen = Center(child: Text('Feed Screen Placeholder'));
  final Widget searchScreen = Center(child: Text('Search Screen'));
  final Widget favoriteScreen = Center(child: Text('Favorite Screen'));
  final Widget profileScreen = Center(child: Text('Profile Screen'));

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Initialize the pages without the PostScreen
    pages = [
      FeedScreen(),
      searchScreen, // Replace with actual screen when available
      favoriteScreen, // Replace with actual screen when available
      profileScreen, // Replace with actual screen when available
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          // Update the index and rebuild the widget to reflect the change
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          // Removed the PostScreen icon here
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        // Removed the PostScreen from the count
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
