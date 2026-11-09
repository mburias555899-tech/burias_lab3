
import 'package:flutter/material.dart';

void main() {
  runApp(const LoginRegisterApp());
}

class LoginRegisterApp extends StatelessWidget {
  const LoginRegisterApp({super.key});

  static const Color dandelion = Color(0xFFF4D35E);
  static const Color cream = Color(0xFFFFF9E8);
  static const Color brown = Color(0xFF55472A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dandelion Auth',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dandelion,
          primary: brown,
          surface: cream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: brown,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE8DDBD),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE8DDBD),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: brown,
              width: 1.5,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: dandelion,
            foregroundColor: brown,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _hidePassword = true;
  bool _isLoggedIn = false;

  String? _registeredName;
  String? _registeredEmail;
  String? _registeredPassword;

  static const Color dandelion = Color(0xFFF4D35E);
  static const Color brown = Color(0xFF55472A);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _switchForm() {
    _formKey.currentState?.reset();
    _clearFields();

    setState(() {
      _isLogin = !_isLogin;
      _hidePassword = true;
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (_isLogin) {
      if (_registeredEmail == null) {
        _showMessage('Please register an account first.');
        return;
      }

      if (email != _registeredEmail ||
          password != _registeredPassword) {
        _showMessage('Incorrect email or password.');
        return;
      }

      _clearFields();

      setState(() {
        _isLoggedIn = true;
      });
    } else {
      if (_registeredEmail != null) {
        _showMessage(
          'An account already exists. Please log in.',
        );
        return;
      }

      _registeredName = _nameController.text.trim();
      _registeredEmail = email;
      _registeredPassword = password;

      _formKey.currentState!.reset();
      _clearFields();

      setState(() {
        _isLogin = true;
        _hidePassword = true;
      });

      _showMessage('Registration successful! Please log in.');
    }
  }

  void _logout() {
    _clearFields();

    setState(() {
      _isLoggedIn = false;
      _isLogin = true;
      _hidePassword = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: dandelion,
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 62,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, $_registeredName!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _registeredEmail ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Login' : 'Register',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: dandelion,
                      child: Icon(
                        Icons.local_florist_rounded,
                        size: 48,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isLogin
                          ? 'Welcome Back!'
                          : 'Create an Account',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Please log in to continue.'
                          : 'Fill in your details to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: brown.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _nameController,
                        textCapitalization:
                            TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter your full name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Please enter your email.';
                        }

                        final emailPattern = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );

                        if (!emailPattern.hasMatch(email)) {
                          return 'Please enter a valid email.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password.';
                        }

                        if (value.length < 8) {
                          return 'Use at least 8 characters.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    if (!_isLogin) ...[
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _hidePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password.';
                          }

                          if (value !=
                              _passwordController.text) {
                            return 'Passwords do not match.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        _isLogin ? 'Login' : 'Register',
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: _switchForm,
                      child: Text(
                        _isLogin
                            ? 'No account yet? Register'
                            : 'Already have an account? Login',
                        style: const TextStyle(
                          color: brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      'Ma. Bea Julia L. Burias | Section: CCE106 3450',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: brown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
