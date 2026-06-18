import '../../../../core/utils/json_read.dart';
import 'blog_image_dto.dart';

/// Swagger: GetBlogDTO
class GetBlogDto {
  const GetBlogDto({
    this.blogId,
    required this.title,
    required this.description,
    required this.topic,
    required this.consultantName,
    required this.thumbnailImagePath,
    this.publishDate,
  });

  final int? blogId;
  final String title;
  final String description;
  final String topic;
  final DateTime? publishDate;
  final String consultantName;
  final String thumbnailImagePath;

  factory GetBlogDto.fromJson(Map<String, dynamic> json) => GetBlogDto(
        blogId: JsonRead.intValue(json, 'blogID'),
        title: JsonRead.string(json, 'title') ?? '',
        description: JsonRead.string(json, 'description') ?? '',
        topic: JsonRead.string(json, 'topic') ?? '',
        publishDate: JsonRead.dateTime(json, 'publishDate'),
        consultantName: JsonRead.string(json, 'consultantName') ?? '',
        thumbnailImagePath: JsonRead.string(json, 'thumbnailImagePath') ?? '',
      );
}

/// Swagger: BlogContentDTO
class BlogContentDto {
  const BlogContentDto({
    required this.blogId,
    required this.title,
    required this.content,
    required this.topic,
    required this.consultantName,
    this.publishDate,
    this.images = const [],
    this.description,
  });

  final int blogId;
  final String title;
  final String content;
  final String topic;
  final DateTime? publishDate;
  final String consultantName;
  final List<BlogImageDto> images;
  final String? description;

  factory BlogContentDto.fromJson(Map<String, dynamic> json) => BlogContentDto(
        blogId: JsonRead.intValue(json, 'blogID') ?? 0,
        title: JsonRead.string(json, 'title') ?? '',
        content: JsonRead.string(json, 'content') ?? '',
        topic: JsonRead.string(json, 'topic') ?? '',
        publishDate: JsonRead.dateTime(json, 'publishDate'),
        consultantName: JsonRead.string(json, 'consultantName') ?? '',
        images: JsonRead.mapList(json['images'])
            .map(BlogImageDto.fromJson)
            .toList(),
        description: JsonRead.string(json, 'description'),
      );
}
