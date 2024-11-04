import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_icons.dart';

class BottomNavigatorComponent extends StatelessWidget {
  final List<BottomNavigatorItemComponent> items;
  final int currentIndex;
  final ValueChanged<int> onTap; // Usando ValueChanged para melhor clareza

  const BottomNavigatorComponent({
    super.key,
    required this.items,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 1,
            color: AppColors.grey2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items
                  .map((e) => e.copyWith(
                        isActive: items.indexOf(e) == currentIndex,
                        onTap: () => onTap(items.indexOf(e)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigatorItemComponent extends StatelessWidget {
  final String label;
  final String activeIcon;
  final String icon;
  final bool isActive;
  final VoidCallback onTap; // Alterando para VoidCallback

  BottomNavigatorItemComponent copyWith({
    String? label,
    String? activeIcon,
    String? icon,
    bool? isActive,
    VoidCallback? onTap,
  }) {
    return BottomNavigatorItemComponent(
      label: label ?? this.label,
      activeIcon: activeIcon ?? this.activeIcon,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      onTap: onTap ?? this.onTap,
    );
  }

  const BottomNavigatorItemComponent(
      {required this.label,
      required this.activeIcon,
      required this.icon,
      this.isActive = false,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            AppIcon(
              isActive ? activeIcon : icon,
              size: const Size(20, 20),
              color: AppColors.grey7 ?? Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
