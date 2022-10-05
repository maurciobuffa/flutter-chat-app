import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Loading Page'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authenticated = await authService.isLoggedIn();

    if (authenticated) {
      socketService.connect();
      if (mounted) {
        // Navigator.pushReplacementNamed(context, 'users');
        Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => const UsersPage()));
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => const LoginPage()));
      }
    }
  }
}
