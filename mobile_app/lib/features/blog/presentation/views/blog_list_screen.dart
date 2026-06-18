import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/filter_chip_bar.dart';
import '../../../../core/widgets/search_bar.dart' show AppSearchBar;
import '../../../../core/widgets/section_header.dart';
import '../../../../routes/route_names.dart';
import '../presenters/blog_presenter.dart';
import '../presenters/blog_view_status.dart';
import '../widgets/blog_card.dart';

/// Health blog catalog powered by `GET /api/blogs`.
class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogPresenter>().loadBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogPresenter>(
      builder: (context, presenter, _) {
        return AppScaffold(
          body: RefreshIndicator(
            onRefresh: presenter.refreshBlogs,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SectionHeader(
                        title: 'Bài viết sức khỏe',
                        subtitle:
                            'Kiến thức và mẹo chăm sóc sức khỏe giới tính.',
                        responsive: false,
                      ),
                      AppSearchBar(
                        hint: 'Tìm bài viết...',
                        onChanged: presenter.setSearchQuery,
                        responsive: false,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (presenter.topics.isNotEmpty)
                        TopicFilterChipBar(
                          topics: presenter.topics,
                          selected: presenter.selectedTopic,
                          onChanged: presenter.setTopicFilter,
                        ),
                      const SizedBox(height: AppSpacing.lg),
                    ]),
                  ),
                ),
                _buildBodySliver(context, presenter),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodySliver(BuildContext context, BlogPresenter presenter) {
    return switch (presenter.listStatus) {
      BlogViewStatus.loading || BlogViewStatus.idle =>
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: LoadingWidget(message: 'Đang tải bài viết...'),
          ),
        ),
      BlogViewStatus.error => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: AppErrorWidget(
              message: presenter.listErrorMessage ??
                  'Không thể tải danh sách bài viết.',
              onRetry: presenter.loadBlogs,
            ),
          ),
        ),
      BlogViewStatus.empty => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: EmptyStateWidget(
              title: 'Không tìm thấy bài viết',
              message: presenter.searchQuery.isNotEmpty ||
                      presenter.selectedTopic != null
                  ? 'Thử từ khóa hoặc chủ đề khác.'
                  : 'Hiện chưa có bài viết nào.',
              icon: Icons.search_off_outlined,
            ),
          ),
        ),
      BlogViewStatus.success => SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(top: 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final blog = presenter.blogs[index];
                final blogId = blog.blogId;
                return BlogCard(
                  blog: blog,
                  onTap: blogId == null
                      ? () {}
                      : () => context.pushNamed(
                            RouteNames.blogDetail,
                            pathParameters: {
                              'id': blogId.toString(),
                            },
                          ),
                );
              },
              childCount: presenter.blogs.length,
            ),
          ),
        ),
    };
  }
}
