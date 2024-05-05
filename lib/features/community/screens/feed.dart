// lib/features/community/screens/feed.dart
import 'package:flutter/material.dart';
import 'package:byte_app/features/community/models/post_model.dart';
import 'package:byte_app/features/community/widgets/post_widget.dart';
import 'package:byte_app/features/community/widgets/topic_tabs_widget.dart';
import 'package:byte_app/features/community/services/post_service.dart';
import 'package:byte_app/features/community/screens/comment_screen.dart';
import 'package:byte_app/features/community/pagination/pagination_manager.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>{
  final PostService _postService = PostService();
  final PaginationManager _paginationManager = PaginationManager();
  final ScrollController _scrollController = ScrollController();

  // To hold the selected category state
  String _selectedCategory = "";

  @override
  void initState() {
    super.initState();

    _paginationManager.onDataFetched = () {
      // This will re-render the UI after more posts are fetched
      setState(() {});
    };

    _paginationManager.fetchInitialPosts().then((_) {
      setState(() {
        // This might be redundant if fetchInitialPosts already triggers onDataFetched
      });
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_paginationManager.isFetching &&
        _paginationManager.canFetchMore) {
      _paginationManager.fetchMorePosts();
    }
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _paginationManager.fetchInitialPosts(category: _selectedCategory);
    }
  }

  void _refreshPost(String postId) {
    _postService.getPostById(postId).then((updatedPost) {
      setState(() {
        int index = _paginationManager.posts.indexWhere((post) => post.id == postId);
        if (index != -1 && updatedPost != null) {
          _paginationManager.posts[index] = updatedPost;
        }
      });
    }).catchError((error) {
      print("Error updating post: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // This number should match the number of tabs if statically defined
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TopicTabWidget(onCategorySelected: _onCategorySelected),
          ),
        ),
        body: ListView.builder(
          controller: _scrollController,
          itemCount:
          _paginationManager.posts.length + (_paginationManager.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _paginationManager.posts.length) {
              return _paginationManager.hasMore
                  ? Center(child: CircularProgressIndicator())
                  : Center(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("No more posts", style: TextStyle(fontSize: 16)),
              ));
            }
            final post = _paginationManager.posts[index];
            return PostWidget(
              key: ValueKey(post.id),
              post: post,
              profileImage: post.authorProfileImage,
              onLike: () {},
              onComment: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(postId: post.id),
                  ),
                );
                _refreshPost(post.id);  // Refresh post details after returning from comments screen
              },
              onVote: (String question, String option) async {
                await _postService.voteOnOption(question, option);
                // Optionally, manage state updates if needed
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
