// lib/features/community/screens/homedecider.dart
import 'package:flutter/material.dart';
import 'package:byte_app/services/admin_service.dart';
import 'package:byte_app/features/community/screens/home.dart';
import 'package:byte_app/features/community/screens/home_without_post.dart';

class HomeDecider extends StatefulWidget {
  @override
  _HomeDeciderState createState() => _HomeDeciderState();
}

class _HomeDeciderState extends State<HomeDecider> {
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  void _checkAdminStatus() async {
    bool adminStatus = await AdminService().isAdmin();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isAdmin == null) {
      // You might want to show a loading indicator while the check is in progress
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (isAdmin!) {
      // If user is admin, show the home with post button
      return Home();
    } else {
      // If user is not admin, show the home without post button
      return HomeWithoutPost();
    }
  }
}
