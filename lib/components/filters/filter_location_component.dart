import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FilterLocationComponent extends StatefulWidget {
  const FilterLocationComponent({
    super.key,
    required this.selectedDimension,
    required this.onChanged,
  });

  final String? selectedDimension;
  final ValueChanged<String?> onChanged;

  @override
  State<FilterLocationComponent> createState() => _FilterLocationComponentState();
}

class _FilterLocationComponentState extends State<FilterLocationComponent> {
  final MenuController _menuController = MenuController();
  final TextEditingController _customInputController = TextEditingController();
  
  String? _tempSelectedOption;
  bool _showCustomInput = false; 

  static const List<String> _commonDimensions = [
    'Replacement Dimension',
    'Dimension C-137',
    'unknown',
    'Fantasy Dimension',
  ];

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    final current = widget.selectedDimension;
    
    if (current == null) {
      _tempSelectedOption = null;
      _showCustomInput = false;
      _customInputController.clear();
    } else if (_commonDimensions.contains(current)) {
      _tempSelectedOption = current;
      _showCustomInput = false;
      _customInputController.clear();
    } else {
      _tempSelectedOption = 'Other';
      _showCustomInput = true;
      _customInputController.text = current;
    }
  }

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
              setState(() => _initializeState());
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
                    'Filter by Dimension',
                    style: TextStyle(
                      color: AppColors.primaryColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Dimension'),
                    dropdownColor: Colors.grey[850],
                    value: _tempSelectedOption,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All', style: TextStyle(color: Colors.white)),
                      ),
                      ..._commonDimensions.map((val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val, style: TextStyle(color: Colors.white)),
                        );
                      }),
                      const DropdownMenuItem<String>(
                        value: 'Other',
                        child: Text('Other (Type manually)', style: TextStyle(color: Color(0xFFEDBD48))),
                      ),
                    ],
                    onChanged: (value) {
                      localSetState(() {
                        _tempSelectedOption = value;
                        _showCustomInput = (value == 'Other');
                        if (!_showCustomInput) _customInputController.clear();
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColorLight),
                  ),

                  if (_showCustomInput) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _customInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Type dimension name...'),
                    ),
                  ],

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
                          String? finalValue;
                          
                          if (_tempSelectedOption == 'Other') {
                            final text = _customInputController.text.trim();
                            finalValue = text.isNotEmpty ? text : null;
                          } else {
                            finalValue = _tempSelectedOption;
                          }

                          widget.onChanged(finalValue);
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
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
    );
  }
}