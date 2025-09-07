import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rick_morty_app/services/favorites_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.characterId,
    this.size = 20,
    this.padding = EdgeInsets.zero,
    this.useCircleBackground = false,
    this.onToggled,
  });

  final int characterId;
  final double size;
  final EdgeInsetsGeometry padding;
  final bool useCircleBackground;
  final VoidCallback? onToggled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: FavoritesService.instance.favorites,
      builder: (_, favs, __) {
        final isFav = favs.contains(characterId);
        final icon = isFav ? Icons.favorite : Icons.favorite_border;
        final iconColor = AppColors.white;
        final tooltip = isFav ? 'Remove from favorites' : 'Add to favorites';

        Widget button = IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: Icon(icon, color: iconColor, size: size),
          tooltip: tooltip,
          onPressed: () async {
            final wasFav = isFav;

            await FavoritesService.instance.toggle(characterId);

            final nowFav = FavoritesService.instance.favorites.value.contains(characterId);

            if (wasFav != nowFav){
              HapticFeedback.lightImpact();
            }
            onToggled?.call();
          },
        );

        if (useCircleBackground) {
          button = Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 0.75,
              ),
            ),
            child: button,
          );
        }

        return Padding(
          padding: padding,
          child: Semantics(
            button: true,
            label: tooltip,
            child: button,
          ),
        );
      },
    );
  }
}
