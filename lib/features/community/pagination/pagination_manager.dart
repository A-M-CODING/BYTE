// lib/features/community/pagination/pagination_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/community/models/post_model.dart';

class PaginationManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<PostModel> posts = [];
  DocumentSnapshot? lastDocument;
  bool hasMore = true;
  final int pageSize = 5;
  bool isLoading = false;
  String currentCategory = "";  // Holds the current selected category for filtering
  // Constructor with callback
  void Function()? onDataFetched;

  PaginationManager({this.onDataFetched});
  // Helper method to format the category for the query
  String _formatCategoryForQuery(String category) {
    return category;
  }

  // Fetch the initial batch of posts with optional category filter
  Future<void> fetchInitialPosts({String category = ""}) async {
    if (isLoading) return;

    currentCategory = category;  // Update current category
    isLoading = true;
    hasMore = true;
    posts.clear();
    lastDocument = null;
    String formattedCategory = _formatCategoryForQuery(category);

    Query query = _firestore.collection('posts').orderBy('timestamp', descending: true);
    if (formattedCategory.isNotEmpty) {
      query = query.where('categories', arrayContains: formattedCategory);
    }
    query = query.limit(pageSize);

    try {
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        posts = snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList();
        hasMore = snapshot.docs.length == pageSize;
      } else {
        hasMore = false;
      }
    } catch (e) {
      print('Error fetching initial posts: $e');
      hasMore = false;
    } finally {
      isLoading = false;
      onDataFetched?.call();
    }
  }

  // Fetch more posts with category handling
  Future<void> fetchMorePosts() async {
    if (isLoading || !hasMore || lastDocument == null) return;

    isLoading = true;
    String formattedCategory = _formatCategoryForQuery(currentCategory);
    Query query = _firestore.collection('posts').orderBy('timestamp', descending: true);
    if (formattedCategory.isNotEmpty) {
      query = query.where('categories', arrayContains: formattedCategory);
    }
    query = query.startAfterDocument(lastDocument!).limit(pageSize);

    try {
      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        posts.addAll(snapshot.docs.map((doc) => PostModel.fromDocument(doc)).toList());
        hasMore = snapshot.docs.length == pageSize;
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching more posts: $e");
      hasMore = false;
    } finally {
      isLoading = false;
      onDataFetched?.call();
    }
  }

  // Reset pagination with new category filter
  void changeCategory(String newCategory) {
    fetchInitialPosts(category: newCategory);
  }

  // Getter to expose the current list of posts and loading status externally
  List<PostModel> get currentPosts => posts;
  bool get isFetching => isLoading;
  bool get canFetchMore => hasMore;
}
