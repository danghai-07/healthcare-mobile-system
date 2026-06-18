import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/blog.dart';
import '../../domain/repositories/blog_repository.dart';
import 'blog_view_status.dart';

/// MVP presenter for blog discovery and reading.
class BlogPresenter extends ChangeNotifier {
  BlogPresenter({
    required BlogRepository blogRepository,
  }) : _blogRepository = blogRepository;

  final BlogRepository _blogRepository;

  BlogViewStatus _listStatus = BlogViewStatus.idle;
  BlogViewStatus _detailStatus = BlogViewStatus.idle;

  List<BlogSummary> _allBlogs = [];
  List<BlogSummary> _blogs = [];
  BlogContent? _blogDetail;

  String? _selectedTopic;
  String _searchQuery = '';
  String? _listErrorMessage;
  String? _detailErrorMessage;

  BlogViewStatus get listStatus => _listStatus;
  BlogViewStatus get detailStatus => _detailStatus;
  List<BlogSummary> get blogs => _blogs;
  BlogContent? get blogDetail => _blogDetail;
  String? get selectedTopic => _selectedTopic;
  String get searchQuery => _searchQuery;
  String? get listErrorMessage => _listErrorMessage;
  String? get detailErrorMessage => _detailErrorMessage;

  List<String> get topics {
    final values = _allBlogs
        .map((blog) => blog.topic.trim())
        .where((topic) => topic.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  Future<void> loadBlogs() async {
    _listStatus = BlogViewStatus.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      _allBlogs = await _blogRepository.getAllBlogs();
      _allBlogs.sort(
        (a, b) => (b.publishDate ?? DateTime(1970))
            .compareTo(a.publishDate ?? DateTime(1970)),
      );
      _applyFilters();
    } on ApiException catch (error) {
      _listErrorMessage = error.message;
      _listStatus = BlogViewStatus.error;
    } catch (_) {
      _listErrorMessage = 'Không thể tải danh sách bài viết.';
      _listStatus = BlogViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> refreshBlogs() => loadBlogs();

  Future<void> loadBlogDetail(int blogId) async {
    _detailStatus = BlogViewStatus.loading;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _blogDetail = await _blogRepository.getBlogById(blogId);
      _detailStatus = BlogViewStatus.success;
    } on ApiException catch (error) {
      _detailErrorMessage = error.message;
      _detailStatus = BlogViewStatus.error;
    } catch (_) {
      _detailErrorMessage = 'Không thể tải chi tiết bài viết.';
      _detailStatus = BlogViewStatus.error;
    }

    notifyListeners();
  }

  void setTopicFilter(String? topic) {
    if (_selectedTopic == topic) {
      return;
    }
    _selectedTopic = topic;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  void _applyFilters() {
    _blogs = _allBlogs.where((blog) {
      final matchesTopic = _selectedTopic == null ||
          _selectedTopic!.isEmpty ||
          blog.topic == _selectedTopic;
      if (!matchesTopic) {
        return false;
      }

      if (_searchQuery.isEmpty) {
        return true;
      }

      final query = _searchQuery.toLowerCase();
      return blog.title.toLowerCase().contains(query) ||
          blog.description.toLowerCase().contains(query) ||
          blog.consultantName.toLowerCase().contains(query) ||
          blog.topic.toLowerCase().contains(query);
    }).toList();

    _listStatus = _blogs.isEmpty
        ? BlogViewStatus.empty
        : BlogViewStatus.success;
    notifyListeners();
  }
}
