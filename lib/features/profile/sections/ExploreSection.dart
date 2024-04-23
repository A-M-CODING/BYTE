import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double width;

  const ExploreCard({
    Key? key,
    required this.title,
    required this.iconData,
    required this.color,
    required this.onTap,
    this.width = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: width,
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