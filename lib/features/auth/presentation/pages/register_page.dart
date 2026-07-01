import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/features/auth/presentation/widgets/auth_button_widget.dart';
import 'package:spend_wise/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../app/routes/route_names.dart';
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

    Future<void> register() async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
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

      context.read<AuthCubit>().register(email: email, password: password);
    }

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.auth_register_title.tr())),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              Navigator.of(
                context,
              ).pushReplacementNamed(RouteNames.mainShellPage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Register Success"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.status == AuthStatus.emailVerificationRequired &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.orange,
                ),
              );
            } else if (state.status == AuthStatus.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
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
                    AuthTextFormField(
                      controller: emailController,
                      label: LocaleKeys.auth_email.tr(),
                      keyboardType: TextInputType.emailAddress,
                      isPassword: false,
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
                      prefixIcon: const Icon(Icons.email_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    AuthTextFormField(
                      controller: passwordController,
                      label: LocaleKeys.auth_password.tr(),
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.auth_validation_password_required
                              .tr();
                        }
                        if (value.length < 6) {
                          return LocaleKeys.auth_validation_password_length
                              .tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AuthTextFormField(
                      controller: confirmPasswordController,
                      label: LocaleKeys.auth_confirm_password.tr(),
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.auth_validation_password_required
                              .tr();
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    AuthButtonWidget(
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: register,
                      label: LocaleKeys.auth_register_button.tr(),
                      icon: Icon(Icons.login),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () => LoginPage.open(context),
                      child: Text(
                        LocaleKeys.auth_already_have_account.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
