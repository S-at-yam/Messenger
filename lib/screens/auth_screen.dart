import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  String _enteredUsername = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
    } else {
      return;
    }

    try {
      UserCredential userCredentials;
      if (_isLogin) {
        userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({'email': _enteredEmail, 'username': _enteredUsername});
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                width: 300,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: EdgeInsets.all(12),
                color: Theme.of(context).colorScheme.shadow,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              label: Text('Enter your email address'),
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixedDim,
                                fontSize: 16,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.amber),
                            textCapitalization: TextCapitalization.none,

                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondaryFixedDim,
                                  fontSize: 16,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(color: Colors.amber),
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },

                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),

                          TextFormField(
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.amber),
                            decoration: InputDecoration(
                              label: Text('Enter your password'),
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixedDim,
                                fontSize: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(
                                  context,
                                ).colorScheme.outline.withAlpha(90),
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Sign in' : 'Sign up',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixedDim,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account'
                                  : 'I already have an account',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
