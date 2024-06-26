// lib/features/community/screens/homedecider.dart
import 'package:flutter/material.dart';
import 'package:byte_app/services/admin_service.dart';
import 'package:byte_app/features/profile/screens/profile_page.dart';
import 'package:byte_app/features/profile/screens/profile_page_admin.dart';

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
      // Show a loading indicator while the admin check is in progress
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      // Navigate based on the admin status
      return isAdmin! ? ProfilePageAdmin() : ProfilePage();
    }
  }
}
