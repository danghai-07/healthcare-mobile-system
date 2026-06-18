class BlogSummary {
  const BlogSummary({
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
}

class BlogContent {
  const BlogContent({
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
  final List<BlogImage> images;
  final String? description;
}

class BlogImage {
  const BlogImage({
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
}
