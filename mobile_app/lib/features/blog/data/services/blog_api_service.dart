import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/response_parser.dart';
import '../dtos/blog_dto.dart';

class BlogApiService {
  BlogApiService(this._client);

  final DioClient _client;

  Future<List<GetBlogDto>> getAllBlogs() async {
    final response = await _client.get<dynamic>(ApiEndpoints.blogs);
    return ResponseParser.parseList(
      response.data,
      GetBlogDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<BlogContentDto> getBlogById(int id) async {
    final response = await _client.get<dynamic>('${ApiEndpoints.blogs}/$id');
    return ResponseParser.parseObject(
      response.data,
      BlogContentDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<List<GetBlogDto>> getPopularBlogs({int count = 5}) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.blogsPopular,
      queryParameters: {'count': count},
    );
    return ResponseParser.parseList(
      response.data,
      GetBlogDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<List<GetBlogDto>> getBlogsByTopic(String topic) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.blogsByTopic}/$topic',
    );
    return ResponseParser.parseList(
      response.data,
      GetBlogDto.fromJson,
      expectEnvelope: false,
    );
  }

  Future<BlogContentDto> getBlogByTitle(String title) async {
    final response = await _client.get<dynamic>(
      '${ApiEndpoints.blogsByTitle}/$title',
    );
    return ResponseParser.parseObject(
      response.data,
      BlogContentDto.fromJson,
      expectEnvelope: false,
    );
  }
}
