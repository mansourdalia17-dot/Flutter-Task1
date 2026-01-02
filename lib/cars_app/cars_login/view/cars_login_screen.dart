import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studio_project/cars_app/core/auth_storage.dart';
import 'package:studio_project/cars_app/core/carzy_theme.dart';
import 'package:studio_project/cars_app/cars_login/cubit/login_cubit.dart';
import 'package:studio_project/cars_app/cars_login/state/login_state.dart';
import 'package:studio_project/cars_app/cars_login/view/cars_signup_screen.dart';
import 'package:studio_project/cars_app/main_layout.dart';
import 'package:studio_project/feature/splash_screen/splash_screen.dart';

// ✅ TODO: change this import to your real splash screen file

class CarsLoginScreen extends StatefulWidget {
  const CarsLoginScreen({super.key});

  @override
  State<CarsLoginScreen> createState() => _CarsLoginScreenState();
}

class _CarsLoginScreenState extends State<CarsLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  // ✅ Remember me
  bool _rememberMe = true;
  static const _kRememberMe = 'carzy_remember_me';
  static const _kRememberedEmail = 'carzy_remembered_email';

  @override
  void initState() {
    super.initState();
    _loadRemembered();
  }

  Future<void> _loadRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_kRememberMe) ?? true;
    final savedEmail = prefs.getString(_kRememberedEmail) ?? '';

    if (!mounted) return;
    setState(() {
      _rememberMe = remember;
      if (_rememberMe && savedEmail.isNotEmpty) {
        _email.text = savedEmail;
      }
    });
  }

  Future<void> _persistRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMe, _rememberMe);

    if (_rememberMe) {
      await prefs.setString(_kRememberedEmail, _email.text.trim());
    } else {
      await prefs.remove(_kRememberedEmail);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ keep email if remember is ON (don’t store password)
    await _persistRememberedEmail();

    context.read<LoginCubit>().login(
      email: _email.text.trim(),
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: CarZyTheme.bg,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                return;
              }

              if (state is LoginSuccess) {
                final token = state.login.token;

                if (token == null || token.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('token_missing'.tr())),
                  );
                  return;
                }

                await AuthStorage.saveSession(
                  token: token,
                  user: state.login.user,
                );

                if (!context.mounted) return;

                // ✅ Go to Splash FIRST (download there), then splash opens MainLayout
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const SplashScreen(), // ✅ your splash
                  ),
                      (_) => false,
                );

                // If your SplashScreen needs a "next page", you can do:
                // MaterialPageRoute(builder: (_) => SplashScreen(next: const MainLayout()))
              }
            },
            builder: (context, state) {
              final loading = state is LoginLoading;

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: 20,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Back to TOP (as before): app name left, localization icon right
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_car_filled,
                                color: CarZyTheme.red,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Car",
                                      style: TextStyle(color: CarZyTheme.navy),
                                    ),
                                    TextSpan(
                                      text: "Zy",
                                      style: TextStyle(color: CarZyTheme.red),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'language'.tr(),
                                icon: const Icon(Icons.public_rounded),
                                onPressed: () => _showLanguageSheet(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ✅ Title under the app name to the LEFT (as before)
                          Text(
                            'sign_in_title'.tr(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'enter_credentials'.tr(),
                            style: const TextStyle(color: CarZyTheme.muted),
                          ),
                          const SizedBox(height: 18),

                          // ✅ Card stays the same
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
                                      if (v == null || v.trim().isEmpty) {
                                        return 'required'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: _password,
                                    obscureText: _hide,
                                    decoration: CarZyTheme.fieldDecoration(
                                      hint: 'password_hint'.tr(),
                                      icon: Icons.lock_outline,
                                    ).copyWith(
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(() => _hide = !_hide),
                                        icon: Icon(
                                          _hide ? Icons.visibility_off : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'required'.tr();
                                      if (v.length < 6) return 'password_min'.tr();
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 8),

                                  // ✅ Remember me
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (v) async {
                                          setState(() => _rememberMe = v ?? true);
                                          await _persistRememberedEmail();
                                        },
                                        activeColor: CarZyTheme.red,
                                        checkColor: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'remember_me'.tr(),
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'forgot_password'.tr(),
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: loading ? null : () => _submitLogin(context),
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
                                          : Text(
                                        'sign_in'.tr(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
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
                              Text(
                                "no_account".tr(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const CarsSignupScreen()),
                                  );
                                },
                                child: Text(
                                  "sign_up".tr(),
                                  style: const TextStyle(
                                    color: CarZyTheme.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final locales = context.supportedLocales;
    final current = context.locale;

    showModalBottomSheet(
      context: context,
      backgroundColor: CarZyTheme.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'choose_language'.tr(),
                style: TextStyle(
                  color: CarZyTheme.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...locales.map((loc) {
                final selected = loc == current;
                return ListTile(
                  leading: Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected ? CarZyTheme.red : Colors.black38,
                  ),
                  title: Text(loc.languageCode.toUpperCase()),
                  onTap: () async {
                    await context.setLocale(loc);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
