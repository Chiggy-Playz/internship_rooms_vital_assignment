import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/login/login.dart';
import 'package:rooms_vital_assignment/signup/signup.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
          context.showSnackBar("Login failed: ${state.error}");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign Up")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    value = value?.trim();
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                  onSaved: (newValue) => email = newValue ?? "",
                ),
                const Gap(16),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) {
                    value = value?.trim();
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  onSaved: (newValue) => password = newValue ?? "",
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text("Log in!"),
                      onPressed: () => context.go(LoginPage.routePath),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.person_add),
                      onPressed: () {
                        if (!(_formKey.currentState!.validate())) {
                          return;
                        }
                        _formKey.currentState!.save();

                        BlocProvider.of<SignUpBloc>(context).add(
                          SignUpSubmitted(
                            email: email,
                            password: password,
                          ),
                        );
                      },
                      label: const Text("Sign up!"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
