import 'package:flutter/material.dart';

class AuthButtonWidget extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Icon icon;
  final VoidCallback onPressed;

  const AuthButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label, required this.icon,
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
            : icon,
        label: Text(label),
      ),
    );
  }
}
