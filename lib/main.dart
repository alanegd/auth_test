import 'package:auth_test/screens/home_screen.dart';
import 'package:auth_test/screens/login_screen.dart';
import 'package:auth_test/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenhouse',
      theme: ThemeData(
        fontFamily: 'Inter',
        splashColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => const LoginScreen();
            break;
          case '/home':
            builder = (BuildContext _) => const HomeScreen();
            break;
          case '/sign-up':
            builder = (BuildContext _) => const SignUpScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
