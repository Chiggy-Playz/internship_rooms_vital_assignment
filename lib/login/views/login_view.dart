import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/login/bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          context.showSnackBar("Login failed: ${state.error}");
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                    onSaved: (newValue) => username = newValue ?? "",
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
                        onPressed: () {},
                        child: const Text("Sign up!"),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          if (!(_formKey.currentState!.validate())) {
                            return;
                          }
                          _formKey.currentState!.save();

                          BlocProvider.of<LoginBloc>(context).add(
                            LoginSubmitted(
                              email: username,
                              password: password,
                            ),
                          );
                        },
                        label: const Text("Login"),
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
        );
      },
    );
  }
}
