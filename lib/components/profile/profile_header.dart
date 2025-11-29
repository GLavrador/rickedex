import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.isEmailVerified,
    required this.onResendVerification,
  });

  final AppUser user;
  final bool isEmailVerified;
  final VoidCallback onResendVerification;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryColorDark,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isEmailVerified ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backgroundColor, width: 2),
                ),
                child: Icon(
                  isEmailVerified ? Icons.check : Icons.priority_high,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Text(
          user.nickname,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.email,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),

        if (!isEmailVerified) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onResendVerification,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: BorderSide(color: Colors.orange.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Email not verified. Resend?"),
          ),
        ],
      ],
    );
  }
}