import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_project/cars_app/core/auth_storage.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars_login/cubit/signup_cubit.dart';
import 'package:studio_project/cars_app/cars_login/model/signup_model.dart';
import 'package:studio_project/cars_app/cars_login/state/signup_state.dart';

class CarsSignupScreen extends StatefulWidget {
  const CarsSignupScreen({super.key});

  @override
  State<CarsSignupScreen> createState() => _CarsSignupScreenState();
}

class _CarsSignupScreenState extends State<CarsSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _hide1 = true;
  bool _hide2 = true;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => SignupCubit(),
      child: Scaffold(
        backgroundColor: CarZyTheme.bg,
        body: SafeArea(
          child: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) async {
              if (state is SignupFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              if (state is SignupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );

                // If register returns token+user => auto login
                final token = state.login?.token;
                if (token != null && token.isNotEmpty) {
                  await AuthStorage.saveSession(token: token, user: state.login?.user);
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                  return;
                }

                // Otherwise go to login
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            builder: (context, state) {
              final loading = state is SignupLoading;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_car_filled, color: CarZyTheme.red, size: 28),
                        const SizedBox(width: 8),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: "Car", style: TextStyle(color: CarZyTheme.navy)),
                              TextSpan(text: "Zy", style: TextStyle(color: CarZyTheme.red)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Text('register_title'.tr(),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('register_subtitle'.tr(), style: const TextStyle(color: CarZyTheme.muted)),
                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: CarZyTheme.navy,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            offset: Offset(0, 10),
                            color: Color(0x22000000),
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'email_hint'.tr(),
                                icon: Icons.email_outlined,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return "Email is required";
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'phone_hint'.tr(),
                                icon: Icons.phone_outlined,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return "Phone is required";
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _password,
                              obscureText: _hide1,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'password_hint'.tr(),
                                icon: Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _hide1 = !_hide1),
                                  icon: Icon(_hide1 ? Icons.visibility_off : Icons.visibility),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Password is required";
                                if (v.length < 6) return "Password must be at least 6 chars";
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _confirm,
                              obscureText: _hide2,
                              decoration: CarZyTheme.fieldDecoration(
                                hint: 'confirm_password_hint'.tr(),
                                icon: Icons.lock_reset_outlined,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _hide2 = !_hide2),
                                  icon: Icon(_hide2 ? Icons.visibility_off : Icons.visibility),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Confirm password is required";
                                if (v != _password.text) return "Passwords do not match";
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                  if (!_formKey.currentState!.validate()) return;

                                  final model = SignupModel(
                                    email: _email.text.trim(),
                                    password: _password.text,
                                    phoneNumber: _phone.text.trim(),
                                  );

                                  context.read<SignupCubit>().signup(model);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CarZyTheme.red,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: loading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text('register'.tr(),
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("have_account".tr(), style: const TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: CarZyTheme.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
