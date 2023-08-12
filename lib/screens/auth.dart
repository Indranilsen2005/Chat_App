import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;

  @override
  Widget build(BuildContext context) {
    Widget passwordBoxPreview = TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.key),
      ),
      obscureText: true,
    );

    if (!_isLogin) {
      passwordBoxPreview = Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.key),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.key),
            ),
            obscureText: true,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                width: 200,
                height: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Text(
                'Welcome to Chat App',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 20),
                        passwordBoxPreview,
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 100,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? 'New User?'
                                  : 'Already have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin ? 'Sign Up' : 'Login',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
