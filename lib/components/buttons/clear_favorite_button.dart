import 'package:flutter/material.dart';
import 'package:rick_morty_app/services/favorites_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class ClearFavoritesButton extends StatelessWidget {
  const ClearFavoritesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.white),
      label: const Text('Clear all favorites', style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        foregroundColor: AppColors.white,
      ),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.primaryColorLight,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            title: const Text('Clear all favorites',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            content: const Text(
              'Are you sure you want to remove all favorites?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColorDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await FavoritesService.instance.clearAll();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Favorites cleaned')),
            );
          }
        }
      },
    );
  }
}
