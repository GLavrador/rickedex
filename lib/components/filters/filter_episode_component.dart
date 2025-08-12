import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FilterEpisodeComponent extends StatefulWidget {
  const FilterEpisodeComponent({
    super.key,
    required this.selectedSeason,
    required this.onChanged,        
  });

  final String? selectedSeason;
  final ValueChanged<String?> onChanged;

  @override
  State<FilterEpisodeComponent> createState() => _FilterEpisodeComponentState();
}

class _FilterEpisodeComponentState extends State<FilterEpisodeComponent> {
  final MenuController _menuController = MenuController();
  String? _tempSeason;

  static const List<String> _seasons = ['S01','S02','S03','S04','S05'];

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.appBarColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      builder: (context, controller, child) {
        return IconButton(
          icon: Icon(Icons.filter_list_rounded, color: AppColors.white, size: 20),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              setState(() => _tempSeason = widget.selectedSeason);
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (context, localSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Episodes',
                    style: TextStyle(
                      color: AppColors.primaryColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Season',
                    value: _tempSeason,
                    items: _seasons,
                    onChanged: (value) => localSetState(() => _tempSeason = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _menuController.close,
                        child: Text('Cancel', style: TextStyle(color: AppColors.white)),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {
                          widget.onChanged(_tempSeason);
                          _menuController.close();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Apply', style: TextStyle(color: AppColors.white)),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primaryColorLight),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColorDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColorDark),
        ),
      ),
      dropdownColor: Colors.grey[850],
      value: value,
      items: [null, ...items].map((val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val ?? 'All', style: TextStyle(color: AppColors.white)),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColorLight),
    );
  }
}
