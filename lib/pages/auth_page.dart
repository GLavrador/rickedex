import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_app/components/app_bar/app_bar_component.dart';
import 'package:rick_morty_app/components/auth/auth_form_content.dart';
import 'package:rick_morty_app/components/dialogs/app_confirmation_dialog.dart';
import 'package:rick_morty_app/services/auth_service.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class AuthPage extends StatefulWidget {
  static const routeId = '/auth';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  String _getFriendlyErrorMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        default:
          return e.message ?? 'An unknown authentication error occurred.';
      }
    }
    return e.toString().replaceAll("Exception: ", "");
  }

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
          message: _getFriendlyErrorMessage(e),
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
        ),
      ),
    );
  }
}