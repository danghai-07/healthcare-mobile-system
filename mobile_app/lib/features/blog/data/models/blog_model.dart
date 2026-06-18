import '../../domain/entities/blog.dart';
import '../dtos/blog_dto.dart';
import '../dtos/blog_image_dto.dart';

class BlogModel {
  const BlogModel._();

  static BlogSummary fromSummaryDto(GetBlogDto dto) => BlogSummary(
        blogId: dto.blogId,
        title: dto.title,
        description: dto.description,
        topic: dto.topic,
        publishDate: dto.publishDate,
        consultantName: dto.consultantName,
        thumbnailImagePath: dto.thumbnailImagePath,
      );

  static BlogContent fromContentDto(BlogContentDto dto) => BlogContent(
        blogId: dto.blogId,
        title: dto.title,
        content: dto.content,
        topic: dto.topic,
        publishDate: dto.publishDate,
        consultantName: dto.consultantName,
        images: dto.images.map(_imageFromDto).toList(),
        description: dto.description,
      );

  static BlogImage _imageFromDto(BlogImageDto dto) => BlogImage(
        imageId: dto.imageId,
        imagePath: dto.imagePath,
        imageCaption: dto.imageCaption,
        uploadDate: dto.uploadDate,
        orderIndex: dto.orderIndex,
      );
}
