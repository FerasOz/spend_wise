import 'package:flutter/material.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/di/injection_container.dart';
import 'package:spend_wise/features/profiles/presentation/cubit/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final profileCubit = sl<ProfileCubit>();
            await profileCubit.loadProfile(session.user.id);
            if (!context.mounted) return;

            if (profileCubit.state.profile == null) {
              Navigator.pushReplacementNamed(
                context,
                RouteNames.completeProfilePage,
                arguments: session.user.id,
              );
            } else {
              Navigator.pushReplacementNamed(context, RouteNames.mainShellPage);
            }
          });

          return const SizedBox.shrink();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, RouteNames.loginPage);
          });

          return const SizedBox.shrink();
        }
      },
    );
  }
}
