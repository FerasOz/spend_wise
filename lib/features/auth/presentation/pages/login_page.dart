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

    Future<void> login() async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState?.save();

      final email = emailController.text.trim();
      final password = passwordController.text;

      context.read<AuthCubit>().login(email: email, password: password);
    }

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.auth_login_title.tr())),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              Navigator.pushReplacementNamed(context, RouteNames.mainShellPage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login Success"),
                  backgroundColor: Colors.green,
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
          child: BlocBuilder<AuthCubit, AuthState>(
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
                        LocaleKeys.auth_login_subtitle.tr(),
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
                            return LocaleKeys.auth_validation_email_required
                                .tr();
                          }
                          final emailRegExp = RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                          );
                          if (!emailRegExp.hasMatch(value.trim())) {
                            return LocaleKeys.auth_validation_invalid_email
                                .tr();
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
                      SizedBox(height: 24.h),
                      AuthButtonWidget(
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: login,
                        label: LocaleKeys.auth_login_button.tr(),
                        icon: Icon(Icons.login),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () => RegisterPage.open(context),
                        child: Text(LocaleKeys.auth_dont_have_account.tr()),
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
