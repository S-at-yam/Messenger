import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
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
                            textCapitalization: TextCapitalization.none,
                          ),
                          TextFormField(
                            obscureText: true,
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
