import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repositories/blog_repository.dart';
import '../presenters/blog_presenter.dart';

/// Provides a scoped [BlogPresenter] for blog screens.
class BlogRouteScope extends StatelessWidget {
  const BlogRouteScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BlogPresenter>(
      create: (context) => BlogPresenter(
        blogRepository: context.read<BlogRepository>(),
      ),
      child: child,
    );
  }
}
