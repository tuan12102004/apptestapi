part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterEvent extends Equatable{}
class LoginRegisterOrInitial extends LoginRegisterEvent{
  @override
  List<Object?> get props => [];
}
class LoginPage extends LoginRegisterEvent{
  final String email;
  final String password;
  LoginPage({required this.email,required this.password});
  @override
  List<Object?> get props => [];
}
class LoginBot extends LoginRegisterEvent{
  @override
  List<Object?> get props => [];
}
class RegisterPage extends LoginRegisterEvent{
  final String email;
  final String name;
  final String password;
  final String confirmPassword;
  RegisterPage({required this.email,required this.password,required this.confirmPassword, required this.name});
  @override
  List<Object?> get props => [email, password, confirmPassword, name];
}
class LoginFacebook extends LoginRegisterEvent{
  @override
  List<Object?> get props => [];
}
class LoginGoogle extends LoginRegisterEvent{
  @override
  List<Object?> get props => [];
}
class SendEmail extends LoginRegisterEvent{
  final String email;
  SendEmail({required this.email});
  @override
  List<Object?> get props => [email];
}
class ShowToastReset extends LoginRegisterEvent {
  @override
  List<Object?> get props => [];
}
class LogOutPage extends LoginRegisterEvent{
  @override
  List<Object?> get props => [];
}


