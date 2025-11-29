import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class LeaderboardUserCard extends StatelessWidget {
  const LeaderboardUserCard({
    super.key,
    required this.user,
    required this.rank,
    required this.score,
  });

  final AppUser user;
  final int rank;
  final int score;

  @override
  Widget build(BuildContext context) {
    final isMe = user.id == AuthService.instance.currentUser.value?.id;

    Color rankColor;
    double scale = 1.0;

    switch (rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); 
        scale = 1.1;
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0);
        scale = 1.05;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); 
        break;
      default:
        rankColor = Colors.white.withValues(alpha: 0.5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe 
            ? AppColors.primaryColorDark.withValues(alpha: 0.3) 
            : AppColors.appBarColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? AppColors.primaryColorLight : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "$rank",
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.w900,
                fontSize: 18 * scale,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryColorDark,
            child: Text(
              user.nickname.isNotEmpty ? user.nickname[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nickname,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isMe ? AppColors.primaryColorLight : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isMe)
                  Text(
                    "(You)",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColorDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$score",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}