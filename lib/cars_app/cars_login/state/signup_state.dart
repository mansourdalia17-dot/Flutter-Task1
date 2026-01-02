import '../model/login_model.dart';

abstract class SignupState {
  const SignupState();
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final String message;
  final LoginModel? login; // if backend returns token on register
  const SignupSuccess({required this.message, this.login});
}

class SignupFailure extends SignupState {
  final String message;
  const SignupFailure(this.message);
}
