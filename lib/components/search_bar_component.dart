import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    super.key,
    required this.controller,
    this.hintText = 'Search character...',
    required this.onSubmitted,
    required this.onClear,
    this.isLoading = false,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitted,
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7)),
            filled: true,
            fillColor: AppColors.primaryColorLight,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: const Icon(Icons.search, color: Colors.white),

            // spinner + clear quando tem texto
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                if (hasText)
                  IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Limpar',
                  ),
              ],
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
          ),
        );
      },
    );
  }
}
