import 'package:flutter/material.dart';

class AuthTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Icon prefixIcon;
  final TextInputAction? textInputAction;

  const AuthTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    required this.isPassword,
    required this.prefixIcon,
    this.textInputAction,
  });

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? isObscured : false,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                icon: isObscured
                    ? Icon(Icons.remove_red_eye_outlined)
                    : Icon(Icons.remove_red_eye),
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
