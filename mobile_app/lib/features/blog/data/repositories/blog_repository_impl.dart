import '../../domain/entities/blog.dart';
import '../../domain/repositories/blog_repository.dart';
import '../models/blog_model.dart';
import '../services/blog_api_service.dart';

class BlogRepositoryImpl implements BlogRepository {
  BlogRepositoryImpl(this._apiService);

  final BlogApiService _apiService;

  @override
  Future<List<BlogSummary>> getAllBlogs() async {
    final dtos = await _apiService.getAllBlogs();
    return dtos.map(BlogModel.fromSummaryDto).toList();
  }

  @override
  Future<BlogContent> getBlogById(int id) async {
    final dto = await _apiService.getBlogById(id);
    return BlogModel.fromContentDto(dto);
  }

  @override
  Future<List<BlogSummary>> getPopularBlogs({int count = 5}) async {
    final dtos = await _apiService.getPopularBlogs(count: count);
    return dtos.map(BlogModel.fromSummaryDto).toList();
  }

  @override
  Future<List<BlogSummary>> getBlogsByTopic(String topic) async {
    final dtos = await _apiService.getBlogsByTopic(topic);
    return dtos.map(BlogModel.fromSummaryDto).toList();
  }

  @override
  Future<BlogContent> getBlogByTitle(String title) async {
    final dto = await _apiService.getBlogByTitle(title);
    return BlogModel.fromContentDto(dto);
  }
}
