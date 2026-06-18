import '../entities/blog.dart';

abstract interface class BlogRepository {
  Future<List<BlogSummary>> getAllBlogs();
  Future<BlogContent> getBlogById(int id);
  Future<List<BlogSummary>> getPopularBlogs({int count = 5});
  Future<List<BlogSummary>> getBlogsByTopic(String topic);
  Future<BlogContent> getBlogByTitle(String title);
}
