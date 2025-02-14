import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/login/bloc/login_bloc.dart';
import 'package:rooms_vital_assignment/signup/views/sign_up_page.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          context.showSnackBar("Login failed: ${state.error}");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
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
                  obscureText: true,
                  onSaved: (newValue) => password = newValue ?? "",
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.go(SignUpPage.routePath),
                      child: const Text("Sign up!"),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.create),
                      onPressed: () {
                        if (!(_formKey.currentState!.validate())) {
                          return;
                        }
                        _formKey.currentState!.save();

                        BlocProvider.of<LoginBloc>(context).add(
                          LoginSubmitted(
                            email: email,
                            password: password,
                          ),
                        );
                      },
                      label: const Text("Login!"),
                    ),
                  ],
                ),
                const Gap(16),
                const Text("- OR -"),
                const Gap(16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.login),
                  onPressed: () =>
                      context.read<LoginBloc>().add(LoginWithGooglePressed()),
                  label: const Text("Login with Google"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
