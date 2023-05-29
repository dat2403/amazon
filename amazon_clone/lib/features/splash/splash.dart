import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../common/widgets/bottom_bar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // call api -> check user -> nav
      authService.getUserData().then((user) {
        if (user != null) {
          if (user.type.toLowerCase() == "admin") {
            Navigator.pushNamed(context, AdminScreen.routeName);
          } else {
            Navigator.pushNamed(context, BottomBar.routeName);
          }
        } else {
          Navigator.pushNamed(context, AuthScreen.routeName);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
