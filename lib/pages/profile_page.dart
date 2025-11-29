import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/dialogs/app_confirmation_dialog.dart';
import 'package:rick_morty_app/components/navigation/side_bar_component.dart';
import 'package:rick_morty_app/components/profile/profile_view.dart'; 
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  static const routeId = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  Future<void> _checkVerification() async {
    await AuthService.instance.reloadUser();
    if (mounted) setState(() {});
  }

  Future<void> _handleLogout() async {
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

  Future<void> _handleResendVerification() async {
    try {
      await AuthService.instance.sendVerificationEmail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent! Check your inbox.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
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

        final isVerified = AuthService.instance.isEmailVerified;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: appBarComponent(context, isMenuAndHome: true),
          drawer: const SideBarComponent(),
          body: ProfileView(
            user: user,
            isEmailVerified: isVerified,
            onRefresh: _checkVerification,
            onResendVerification: _handleResendVerification,
            onLogout: _handleLogout,
          ),
        );
      },
    );
  }
}