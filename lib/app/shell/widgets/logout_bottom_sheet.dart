import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/features/auth/presentation/cubit/auth_cubit.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(width: 64.w, height: 2.h, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            "Logout",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "Are you sure you want to log out?",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(RouteNames.loginPage, (route) => false);
            },
            child: Text(
              "Yes, log out",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No, stay logged in",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
