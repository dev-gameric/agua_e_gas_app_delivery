import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_icons.dart';
import 'package:aguaegas/core/theme/app_typography.dart';

class HeaderLocationComponent extends StatelessWidget {
  final String location;

  const HeaderLocationComponent({required this.location, super.key});
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _HeaderLocationComponentDelegate(location),
    );
  }
}

class _HeaderLocationComponentDelegate extends SliverPersistentHeaderDelegate {
  final String location;

  _HeaderLocationComponentDelegate(this.location);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    location,
                    style: AppTypography.localTextStyle(context),
                  ),
                  const AppIcon(
                    AppIcons.arrowDown,
                    size: Size(20, 20),
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  double get maxExtent => 38;

  @override
  double get minExtent => 38;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
