import '../../../../core/utils/json_read.dart';

/// Swagger: BlogImageDTO
class BlogImageDto {
  const BlogImageDto({
    required this.imageId,
    required this.imagePath,
    required this.imageCaption,
    this.uploadDate,
    required this.orderIndex,
  });

  final int imageId;
  final String imagePath;
  final String imageCaption;
  final DateTime? uploadDate;
  final int orderIndex;

  factory BlogImageDto.fromJson(Map<String, dynamic> json) => BlogImageDto(
        imageId: JsonRead.intValue(json, 'imageID') ?? 0,
        imagePath: JsonRead.string(json, 'imagePath') ?? '',
        imageCaption: JsonRead.string(json, 'imageCaption') ?? '',
        uploadDate: JsonRead.dateTime(json, 'uploadDate'),
        orderIndex: JsonRead.intValue(json, 'orderIndex') ?? 0,
      );
}
