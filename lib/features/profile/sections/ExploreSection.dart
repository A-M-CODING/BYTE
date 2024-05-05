import 'package:flutter/material.dart';
import '../../../app_theme.dart';

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
    this.width = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: width,
      child: Card(
        elevation: 0.0,
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppTheme.of(context).widgetBackground,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 40,
                color: AppTheme.of(context).widgetBackground,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: AppTheme.of(context).title3.copyWith(
                    color: AppTheme.of(context).widgetBackground,
                    fontSize: 12,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
