import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  }) : super(key: key);

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _arrow(
            icon: Icons.chevron_left,
            enabled: currentPage > 1,
            onTap: () => onPageSelected(currentPage - 1),
          ),
          const SizedBox(width: 8),
          _pageSelector(context),
          const SizedBox(width: 8),
          _arrow(
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages,
            onTap: () => onPageSelected(currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _arrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      color: Colors.white,
      disabledColor: Colors.white.withOpacity(0.35),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _pageSelector(BuildContext context) {
    return Container(
      height: 36,
      constraints: const BoxConstraints(minWidth: 88),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
        color: AppColors.primaryColorLight,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: currentPage,
          isDense: true,
          alignment: Alignment.center,
          dropdownColor: AppColors.primaryColorLight,
          iconEnabledColor: Colors.white,
          onChanged: (v) {
            if (v != null && v != currentPage) onPageSelected(v);
          },
          // mesmo comprimento que itens
          selectedItemBuilder: (context) {
            return List<Widget>.generate(
              totalPages,
              (i) {
                final page = i + 1;
                return Center(
                  child: Text(
                    '$page / $totalPages',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            );
          },
          items: List<DropdownMenuItem<int>>.generate(
            totalPages,
            (i) {
              final page = i + 1;
              return DropdownMenuItem<int>(
                value: page,
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        page == currentPage ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
