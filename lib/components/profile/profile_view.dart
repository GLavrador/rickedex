import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/profile/profile_header.dart';
import 'package:rick_morty_app/components/profile/profile_logout_button.dart';
import 'package:rick_morty_app/components/profile/profile_stats_card.dart';
import 'package:rick_morty_app/models/app_user.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.user,
    required this.isEmailVerified,
    required this.onRefresh,
    required this.onResendVerification,
    required this.onLogout,
  });

  final AppUser user;
  final bool isEmailVerified;
  final Future<void> Function() onRefresh;
  final VoidCallback onResendVerification;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {

    final availableHeight = MediaQuery.of(context).size.height - kToolbarHeight - 50;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryColorLight,
      backgroundColor: AppColors.appBarColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: availableHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                ProfileHeader(
                  user: user,
                  isEmailVerified: isEmailVerified,
                  onResendVerification: onResendVerification,
                ),
                
                const SizedBox(height: 32),

                ProfileStatsCard(user: user),

                const Spacer(),

                ProfileLogoutButton(onPressed: onLogout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}