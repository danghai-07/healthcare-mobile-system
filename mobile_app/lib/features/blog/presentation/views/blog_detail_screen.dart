import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/blog.dart';
import '../presenters/blog_presenter.dart';
import '../presenters/blog_view_status.dart';

/// Blog article reader powered by `GET /api/blogs/{id}`.
class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({
    super.key,
    required this.blogId,
  });

  final int blogId;

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogPresenter>().loadBlogDetail(widget.blogId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          title: 'Chi tiết bài viết',
          showBackButton: true,
          body: _buildBody(presenter),
        );
      },
    );
  }

  Widget _buildBody(BlogPresenter presenter) {
    return switch (presenter.detailStatus) {
      BlogViewStatus.loading || BlogViewStatus.idle =>
        const Center(child: LoadingWidget(message: 'Đang tải bài viết...')),
      BlogViewStatus.error => Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.detailErrorMessage ??
                  'Không thể tải chi tiết bài viết.',
              onRetry: () => presenter.loadBlogDetail(widget.blogId),
            ),
          ),
        ),
      BlogViewStatus.success => _buildContent(presenter.blogDetail),
      BlogViewStatus.empty => const SizedBox.shrink(),
    };
  }

  Widget _buildContent(BlogContent? blog) {
    if (blog == null) {
      return const SizedBox.shrink();
    }

    final heroImage = blog.images.isNotEmpty
        ? blog.images.first.imagePath
        : '';

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (heroImage.isNotEmpty)
            ClipRRect(
              borderRadius: AppRadius.card,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.primaryMuted,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
          if (blog.topic.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.chip,
              ),
              child: Text(
                blog.topic,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Text(
            blog.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  blog.consultantName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              if (blog.publishDate != null) ...[
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _formatDate(blog.publishDate!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ],
            ],
          ),
          if (blog.description != null && blog.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              backgroundColor: AppColors.primaryMuted,
              borderColor: AppColors.primaryLight,
              child: Text(
                blog.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Nội dung', responsive: false),
          AppCard(
            child: Text(
              blog.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.65,
                  ),
            ),
          ),
          if (blog.images.length > 1) ...[
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Hình ảnh', responsive: false),
            ...blog.images.skip(1).map(
                  (image) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: ClipRRect(
                      borderRadius: AppRadius.card,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(
                            image.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 180,
                              color: AppColors.surfaceMuted,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                          if (image.imageCaption.isNotEmpty)
                            Padding(
                              padding: AppSpacing.cardPadding,
                              child: Text(
                                image.imageCaption,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
