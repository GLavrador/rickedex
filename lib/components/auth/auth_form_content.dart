import 'package:flutter/material.dart';
import 'package:rick_morty_app/theme/app_colors.dart';

class AuthFormContent extends StatefulWidget {
  const AuthFormContent({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function({
    required bool isLogin,
    required String email,
    required String password,
    String? nickname,
  }) onSubmit;

  @override
  State<AuthFormContent> createState() => _AuthFormContentState();
}

class _AuthFormContentState extends State<AuthFormContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      isLogin: _tabController.index == 0,
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      nickname: _nickCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColorDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryColorLight,
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Sign Up"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return _tabController.index == 1
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTextField(
                        controller: _nickCtrl,
                        label: "Nickname",
                        icon: Icons.person_outline,
                        validator: (v) => v!.length < 3 ? "Min 3 chars" : null,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),

          _buildTextField(
            controller: _emailCtrl,
            label: "Email",
            icon: Icons.email_outlined,
            type: TextInputType.emailAddress,
            validator: (v) => !v!.contains("@") ? "Invalid email" : null,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _passCtrl,
            label: "Password",
            icon: Icons.lock_outline,
            isPass: true,
            validator: (v) => v!.length < 6 ? "Min 6 chars" : null,
          ),
          
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColorLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: widget.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : AnimatedBuilder(
                      animation: _tabController,
                      builder: (_, __) => Text(
                        _tabController.index == 0 ? "Login" : "Create Account",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
    TextInputType? type,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        prefixIcon: Icon(icon, color: AppColors.primaryColorLight),
        filled: true,
        fillColor: AppColors.primaryColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColorLight),
        ),
      ),
    );
  }
}