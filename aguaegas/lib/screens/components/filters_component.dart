import 'package:flutter/material.dart';
import 'package:aguaegas/core/theme/app_colors.dart';
import 'package:aguaegas/core/theme/app_icons.dart';
import 'package:aguaegas/core/theme/app_typography.dart';

class FiltersComponent extends StatelessWidget {
  const FiltersComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _FiltersComponentDelegate(),
    );
  }
}

class _FiltersComponentDelegate extends SliverPersistentHeaderDelegate {
  _FiltersComponentDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white,
      height: 54,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: const [
          SizedBox(width: 16),
          FilterItemComponent(
            key: ValueKey('ordenar'),
            label: 'Ordenar',
            icon: AppIcons.arrowDown,
          ),
          FilterItemComponent(
            key: ValueKey('pra_retirar'),
            label: 'Pra Retirar',
            icon: AppIcons.arrowDown,
          ),
          FilterItemComponent(
            key: ValueKey('entra_gratis'),
            label: 'Entra Grátis',
            icon: AppIcons
                .arrowDown, // Adicione um valor padrão para icon se necessário
          ),
          FilterItemComponent(
            key: ValueKey('vale_refeicao'),
            label: 'Vale Refeição',
            icon: AppIcons
                .arrowDown, // Adicione um valor padrão para icon se necessário
          ),
          FilterItemComponent(
            key: ValueKey('distancia'),
            label: 'Distância',
            icon: AppIcons.arrowDown,
          ),
          FilterItemComponent(
            key: ValueKey('entrega_parceira'),
            label: 'Entrega Parceira',
            icon: AppIcons.arrowDown,
          ),
          FilterItemComponent(
            key: ValueKey('filtros'),
            label: 'Filtros',
            icon: AppIcons.arrowDown,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 54;

  @override
  double get minExtent => 54;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class FilterItemComponent extends StatelessWidget {
  final String label;
  final String icon;

  const FilterItemComponent(
      {required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 14, right: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.white,
          border: Border.all(
            color: AppColors.grey2 ?? Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                label,
                style: AppTypography.filterItemStyle(context)
                    ?.copyWith(color: AppColors.grey7 ?? Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: AppIcon(
                  icon,
                  size: const Size(14, 14),
                  color: AppColors.grey7 ?? Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
