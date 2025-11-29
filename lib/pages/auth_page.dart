import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/auth/auth_form_content.dart';
import 'package:rick_morty_app/components/dialogs/app_confirmation_dialog.dart';
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';
import 'package:rick_morty_app/utils/auth_error_helper.dart'; 

class AuthPage extends StatefulWidget {
  static const routeId = '/auth';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleAuth({
    required bool isLogin,
    required String email,
    required String password,
    String? nickname,
  }) async {
    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        await AuthService.instance.signIn(email, password);
      } else {
        await AuthService.instance.signUp(
          email: email,
          password: password,
          nickname: nickname!,
        );
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLogin ? "Welcome back!" : "Account created!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppConfirmationDialog.show(
          context,
          title: "Authentication Error",
          message: AuthErrorHelper.getFriendlyMessage(e),
          confirmText: "Ok",
          cancelText: null, 
          icon: Icons.error_outline,
          mainColor: Colors.redAccent,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email first."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.resetPassword(email);
      if (mounted) {
        AppConfirmationDialog.show(
          context,
          title: "Email Sent",
          message: "A password reset link has been sent to $email.",
          confirmText: "Ok",
          cancelText: null,
          icon: Icons.mark_email_read,
          mainColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        AppConfirmationDialog.show(
          context,
          title: "Error",
          message: AuthErrorHelper.getFriendlyMessage(e),
          confirmText: "Ok",
          cancelText: null,
          icon: Icons.error_outline,
          mainColor: Colors.redAccent,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(context), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AuthFormContent(
          isLoading: _isLoading,
          onSubmit: _handleAuth,
          onForgotPassword: _handleForgotPassword,
        ),
      ),
    );
  }
}