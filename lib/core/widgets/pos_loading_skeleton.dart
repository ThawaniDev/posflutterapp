import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PosLoadingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const PosLoadingSkeleton({super.key, this.width = double.infinity, required this.height, this.borderRadius = 8});

  /// A list skeleton with [count] rows of card-like placeholders.
  factory PosLoadingSkeleton.list({Key? key, int count = 5}) {
    return _PosListSkeleton(key: key, count: count);
  }

  @override
  State<PosLoadingSkeleton> createState() => _PosLoadingSkeletonState();
}

class _PosLoadingSkeletonState extends State<PosLoadingSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value * 0.1),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class _PosListSkeleton extends PosLoadingSkeleton {
  final int count;

  const _PosListSkeleton({super.key, required this.count}) : super(height: 0);

  @override
  State<PosLoadingSkeleton> createState() => _PosListSkeletonState();
}

class _PosListSkeletonState extends State<_PosListSkeleton> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (widget as _PosListSkeleton).count,
      separatorBuilder: (_, __) => AppSpacing.gapH12,
      itemBuilder: (_, __) => Padding(
        padding: AppSpacing.paddingCardH,
        child: Row(
          children: [
            const PosLoadingSkeleton(width: 48, height: 48, borderRadius: 24),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PosLoadingSkeleton(height: 14, width: MediaQuery.of(context).size.width * 0.4),
                  AppSpacing.gapH8,
                  PosLoadingSkeleton(height: 10, width: MediaQuery.of(context).size.width * 0.6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
