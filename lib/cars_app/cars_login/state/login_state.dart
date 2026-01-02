import '../model/login_model.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginModel login;
  const LoginSuccess(this.login);
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}
