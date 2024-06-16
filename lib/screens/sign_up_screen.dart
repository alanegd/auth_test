// sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:auth_test/models/company.dart';
import 'package:auth_test/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyTinController = TextEditingController();
  final TextEditingController _companyLogoUrlController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _invitationCodeController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user
      await _authService.signUp(
        _usernameController.text,
        _firstNameController.text,
        _lastNameController.text,
        _passwordController.text,
        _invitationCodeController.text,
      );

      // Log in the user to get the token
      final result = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );
      final token = result['token'];

      // Register the company
      final company = Company(
        name: _companyNameController.text,
        tin: _companyTinController.text,
        logoUrl: _companyLogoUrlController.text,
      );
      await _authService.registerCompany(company, token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Sign Up'),
              const SizedBox(height: 20),
              TextField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _companyTinController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company TIN',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _companyLogoUrlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company Logo URL',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _invitationCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Invitation Code',
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
