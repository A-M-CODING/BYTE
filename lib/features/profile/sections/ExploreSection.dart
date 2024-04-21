import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double width; // Add this line to declare width as a property of the class

  const ExploreCard({
    Key? key,
    required this.title,
    required this.iconData,
    required this.color,
    required this.onTap,
    this.width = 150, // Assign a default value if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the provided width in the container
    return Container(
      margin: EdgeInsets.all(8),
      width: width, // Use width from the class property
      child: Card(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
