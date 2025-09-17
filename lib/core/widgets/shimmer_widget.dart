import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors_manager.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  final Widget child;
  final Duration duration;
  final bool enabled;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _animationController.repeat();
    } else if (!widget.enabled && oldWidget.enabled) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: borderRadius,
      ),
      child: const ShimmerWidget(child: SizedBox.expand()),
    );
  }
}

class ShimmerText extends StatelessWidget {
  const ShimmerText({
    required this.text,
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Text(text, style: style, maxLines: maxLines, overflow: overflow),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
    this.height = 80,
    this.leadingSize = 60,
    this.titleWidth = 200,
    this.subtitleWidth = 150,
  });

  final double height;
  final double leadingSize;
  final double titleWidth;
  final double subtitleWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Leading (avatar/icon)
          ShimmerContainer(
            width: leadingSize.w,
            height: leadingSize.w,
            borderRadius: BorderRadius.circular(leadingSize.w / 2),
          ),
          SizedBox(width: 16.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerContainer(
                  width: titleWidth.w,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                SizedBox(height: 8.h),
                ShimmerContainer(
                  width: subtitleWidth.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({
    required this.itemCount,
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.spacing = 12,
  });

  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing.w,
        mainAxisSpacing: spacing.h,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerContainer(borderRadius: BorderRadius.circular(16.r));
      },
    );
  }
}
