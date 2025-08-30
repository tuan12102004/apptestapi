part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterState {}

final class LoginRegisterInitial extends LoginRegisterState {}

enum StatusLogin { initial, success,successGuest, successFB, successGG, failed, loading, loadingGuest, loadingFb, loadingGG,loadingLogout}
enum StatusRegister { initial, success, failed, loading }
enum StatusSendEmail { initial, success, failed, loading }

final class LoginRegisterStates extends Equatable {
  final User? user;
  final String messageLogin;
  final String messageRegister;
  final String messageSend;
  final StatusLogin statusLogin;
  final StatusRegister statusRegister;
  final StatusSendEmail statusSendEmail;
  const LoginRegisterStates({
     this.statusLogin = StatusLogin.initial,
     this.user,
     this.messageLogin = '',
     this.messageRegister = '',
     this.messageSend = '',
     this.statusRegister = StatusRegister.initial,
     this.statusSendEmail = StatusSendEmail.initial,

  });

  LoginRegisterStates copyWith({
    StatusLogin? statusLogin,
    StatusRegister? statusRegister,
    StatusSendEmail? statusSendEmail,
    String? messageLogin,
    String? messageRegister,
    User? user,
    String? messageSend,
  }) {
    return LoginRegisterStates(
      statusLogin: statusLogin ?? this.statusLogin,
      messageLogin: messageLogin ?? this.messageLogin,
      messageRegister: messageRegister ?? this.messageRegister,
      user: user ?? this.user,
      messageSend: messageSend ?? this.messageSend,
      statusRegister: statusRegister ?? this.statusRegister,
      statusSendEmail: statusSendEmail ?? this.statusSendEmail,
    );
  }

  @override
  List<Object?> get props => [
    statusLogin,
    statusRegister,
    messageLogin,
    messageRegister,
    messageSend,
    statusSendEmail,];
}
