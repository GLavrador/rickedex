import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FilterCharacterComponent extends StatefulWidget {
  final Map<String, String?> currentFilters;
  final Function(Map<String, String?>) onApplyFilters;

  const FilterCharacterComponent({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterCharacterComponent> createState() => _FilterCharacterComponentState();
}

class _FilterCharacterComponentState extends State<FilterCharacterComponent> {
  final MenuController _menuController = MenuController();
  Map<String, String?>? _tempFilters;

  static const List<String> genders = ['Male', 'Female', 'Genderless', 'Unknown'];
  static const List<String> statuses = ['Alive', 'Dead', 'Unknown'];
  static const List<String> speciesList = [
    'Alien', 'Animal', 'Cronenberg', 'Disease', 'Human', 'Humanoid', 
    'Mythological Creature', 'Poopybutthole', 'Robot', 'Unknown', 'Outros',
  ];

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.appBarColor),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ),
      builder: (context, controller, child) {
        return IconButton(
          icon: Icon(Icons.filter_list_rounded, color: AppColors.white, size: 30),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              setState(() {
                _tempFilters = Map.from(widget.currentFilters);
              });
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        Container(
          width: 300, 
          padding: EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter localSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Characters',
                    style: TextStyle(color: AppColors.primaryColorLight, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Gender',
                    value: _tempFilters?['gender'],
                    items: genders,
                    onChanged: (value) => localSetState(() => _tempFilters?['gender'] = value),
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Status',
                    value: _tempFilters?['status'],
                    items: statuses,
                    onChanged: (value) => localSetState(() => _tempFilters?['status'] = value),
                  ),
                  SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Species',
                    value: _tempFilters?['species'],
                    items: speciesList,
                    onChanged: (value) => localSetState(() => _tempFilters?['species'] = value),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _menuController.close,
                        child: Text('Cancel', style: TextStyle(color: AppColors.white)),
                      ),
                      SizedBox(width: 6),

                      ElevatedButton(
                        onPressed: () {
                          widget.onApplyFilters(_tempFilters!);
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
      items: [null, ...items].map((val) => DropdownMenuItem<String>(
            value: val,
            child: Text(val ?? 'All', style: TextStyle(color: AppColors.white)),
          )).toList(),
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColorLight),
    );
  }
}