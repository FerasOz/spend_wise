import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/features/profiles/domain/entities/profile.dart';
import 'package:spend_wise/features/profiles/presentation/cubit/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key, this.userId});

  final String? userId;

  static Future<void> open(BuildContext context, {String? userId}) {
    return Navigator.of(
      context,
    ).pushReplacementNamed(RouteNames.completeProfilePage, arguments: userId);
  }

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Add your display name so it appears in your profile.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Display name'),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final navigator = Navigator.of(context);
                  final userId =
                      widget.userId ??
                      context.read<ProfileCubit>().state.profile?.id ??
                      Supabase.instance.client.auth.currentUser?.id;
                  if (userId == null) {
                    navigator.pushReplacementNamed(RouteNames.mainShellPage);
                    return;
                  }

                  final profile = Profile(
                    id: userId,
                    displayName: _nameController.text.trim(),
                    createdAt: DateTime.now(),
                  );

                  await context.read<ProfileCubit>().createOrUpdateProfile(
                    profile,
                  );
                  if (mounted) {
                    navigator.pushReplacementNamed(RouteNames.mainShellPage);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Save profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
