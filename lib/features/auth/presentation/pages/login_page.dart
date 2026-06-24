import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/shell/main_shell_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).pushNamed(RouteNames.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final obscureText = ValueNotifier<bool>(true);

    Future<void> login() async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) return;
      formKey.currentState?.save();

      final email = emailController.text.trim();
      final password = passwordController.text;

      context.read<AuthCubit>().login(
        email: email,
        password: password,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.auth_login_title.tr()),
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              // Navigate to main shell on successful login
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
                        LocaleKeys.auth_login_subtitle.tr(),
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
                        obscureText: obscureText,
                      ),
                      SizedBox(height: 24.h),
                      _LoginButton(
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: login,
                      ),
                      SizedBox(height: 16.h),
                      _SignUpLink(
                        onPressed: () => RegisterPage.open(context),
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

  const _PasswordTextField({
    required this.controller,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText.value,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: LocaleKeys.auth_password.tr(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText.value
                ? Icons.visibility_off
                : Icons.visibility,
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
      onFieldSubmitted: (_) {
        // Trigger login when 'Done' is pressed on keyboard
        // This would need access to the form key and login function
        // For simplicity, we rely on the button press
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
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
            : const Icon(Icons.login),
        label: Text(LocaleKeys.auth_login_button.tr()),
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignUpLink({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(LocaleKeys.auth_dont_have_account.tr()),
    );
  }
}