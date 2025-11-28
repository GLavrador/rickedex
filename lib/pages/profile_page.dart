import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/dialogs/app_confirmation_dialog.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/profile/profile_header.dart'; 
import 'package:rick_morty_app/components/profile/profile_stats_card.dart'; 
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  static const routeId = '/profile';
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await AppConfirmationDialog.show(
      context,
      title: "Logout?",
      message: "Are you sure you want to exit your account?",
      confirmText: "Logout",
      icon: Icons.logout,
    );

    if (confirm) {
      await AuthService.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AuthService.instance.currentUser,
      builder: (context, user, _) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: appBarComponent(context, isMenuAndHome: true),
          drawer: const SideBarComponent(),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ProfileHeader(
                  nickname: user.nickname,
                  email: user.email,
                ),
                
                const SizedBox(height: 32),

                ProfileStatsCard(user: user),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      "Logout", 
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}