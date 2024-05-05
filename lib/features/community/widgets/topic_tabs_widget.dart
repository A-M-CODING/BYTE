// lib/features/community/widgets/topic_tabs_widget.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/app_theme.dart';

class TopicTabWidget extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;

  const TopicTabWidget({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  _TopicTabWidgetState createState() => _TopicTabWidgetState();
}

class _TopicTabWidgetState extends State<TopicTabWidget> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _categories = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTopics().then((categories) {
      setState(() {
        _categories = categories;
        _tabController = TabController(length: _categories.length, vsync: this);
        _tabController!.addListener(_handleTabSelection);
      });
    });
  }

  Future<List<String>> _fetchTopics() async {
    QuerySnapshot snapshot = await _firestore.collection('posts').get();
    Set<String> topicsSet = {"All"};
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> categories = data['categories'] ?? [];
      for (var category in categories) {
        topicsSet.add(category.toString());
      }
    }
    return topicsSet.toList();
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
      String selectedCategory = _categories[_tabController!.index];
      widget.onCategorySelected(selectedCategory == "All" ? "" : selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = AppTheme.of(context);

    return _categories.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: appTheme.secondaryBackground,
        indicator: BoxDecoration(),
        unselectedLabelColor: appTheme.black600,
        tabs: _categories.map((category) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedIndex == _categories.indexOf(category)
                    ? appTheme.secondaryBackground
                    : appTheme.secondaryBackground,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _selectedIndex == _categories.indexOf(category)
                  ? appTheme.secondaryBackground
                  : appTheme.primaryBtnText,
            ),
            child: Text(
              category,
              style: appTheme.typography.bodyText22.copyWith(
                color: _selectedIndex == _categories.indexOf(category)
                    ? appTheme.primaryBtnText
                    : appTheme. alternate,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
