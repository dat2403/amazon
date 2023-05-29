import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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
          // save user in UserProvider...
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);

          if (user.type.toLowerCase() == "admin") {
            Navigator.pushReplacementNamed(context, AdminScreen.routeName);
          } else {
            Navigator.pushReplacementNamed(context, BottomBar.routeName);
          }
        } else {
          Navigator.pushReplacementNamed(context, AuthScreen.routeName);
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
