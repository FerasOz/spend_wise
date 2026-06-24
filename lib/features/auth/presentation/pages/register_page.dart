import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/shell/main_shell_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).pushNamed(RouteNames.registerPage);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final obscurePassword = ValueNotifier<bool>(true);
    final obscureConfirmPassword = ValueNotifier<bool>(true);

    Future<void> register() async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) return;
      formKey.currentState?.save();

      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.auth_validation_passwordsDoNotMatch.tr()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      context.read<AuthCubit>().register(
        email: email,
        password: password,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_register_title.tr()),
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              // Navigate to main shell on successful registration
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const MainShellPage(),
                ),
              );
            } else if (state.status == AuthStatus.error &&
                state.errorMessage != null) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) =>
                previous.status != current.status,
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.auth_register_subtitle.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      _EmailTextField(
                        controller: emailController,
                      ),
                      SizedBox(height: 16.h),
                      _PasswordTextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        labelText: LocaleKeys.auth_password.tr(),
                      ),
                      SizedBox(height: 16.h),
                      _PasswordTextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        labelText: LocaleKeys.auth_confirm_password.tr(),
                      ),
                      SizedBox(height: 24.h),
                      _RegisterButton(
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: register,
                      ),
                      SizedBox(height: 16.h),
                      _LoginLink(
                        onPressed: () => LoginPage.open(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailTextField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: LocaleKeys.auth_email.tr(),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.auth_validation_email_required.tr();
        }
        final emailRegExp = RegExp(
          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        );
        if (!emailRegExp.hasMatch(value.trim())) {
          return LocaleKeys.auth_validation_invalid_email.tr();
        }
        return null;
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> obscureText;
  final String labelText;

  const _PasswordTextField({
    required this.controller,
    required this.obscureText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText.value,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: ValueListenableBuilder<bool>(
            valueListenable: obscureText,
            builder: (context, value, _) {
              return Icon(
                value ? Icons.visibility_off : Icons.visibility,
                size: 20,
              );
            },
          ),
          onPressed: () {
            obscureText.value = !obscureText.value;
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocaleKeys.auth_validation_password_required.tr();
        }
        if (value.length < 6) {
          return LocaleKeys.auth_validation_password_length.tr();
        }
        return null;
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _RegisterButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : Text(
              LocaleKeys.auth_register_button.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginLink({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        LocaleKeys.auth_already_have_account.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}