import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'login_register_event.dart';
part 'login_register_state.dart';

class LoginRegisterBloc extends Bloc<LoginRegisterEvent, LoginRegisterStates> {
  LoginRegisterBloc() : super(LoginRegisterStates()) {
    on<LoginRegisterOrInitial>(_initial);
    on<LoginPage>(_loginPage);
    on<LoginBot>(_loginBot);
    on<RegisterPage>(_registerPage);
    on<SendEmail>(_sendEmail);
    on<LoginFacebook>(_loginFacebook);
    on<LoginGoogle>(_loginGoogle);
    on<ShowToastReset>((event, emit) {
    });
    on<LogOutPage>(_logout);
  }

  void _initial(LoginRegisterOrInitial event,Emitter<LoginRegisterStates> emit){
    emit(state.copyWith(statusLogin: StatusLogin.initial));}
  void _loginPage(LoginPage event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusLogin: StatusLogin.loading));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        statusLogin: StatusLogin.success,
        messageLogin: 'Đăng nhập thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        statusLogin: StatusLogin.failed,
        messageLogin: "Đăng nhập thất bại",
      ));
    }
  }
  void _loginBot(LoginBot event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusLogin: StatusLogin.loadingGuest));
    try {
      await FirebaseAuth.instance.signInAnonymously();
      emit(state.copyWith(
          statusLogin: StatusLogin.success, messageLogin: 'Đăng nhập thành công'));
    } catch (e) {
      emit(state.copyWith(
          statusLogin: StatusLogin.failed, messageLogin: "Đăng nhập thất bại"));
      print('Error anonymous login: $e');
    }
  }
  void _registerPage(RegisterPage event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusRegister: StatusRegister.loading));
    try {
      if(event.password.length < 6){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Mật khẩu phải có ít nhất 6 ký tự'));
        return; }
      if(event.email.isEmpty){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Email không được để trống'));
        return; }
      if(!event.email.contains('@gmail.com')){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Email không hợp lệ thiếu @gmail.com'));
        return; }
      if(event.password.isEmpty){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Mật khẩu không được để trống'));
        return; }
      if(event.confirmPassword.isEmpty){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Xác nhận mật khẩu không được để trống'));
        return; }
      if(event.password != event.confirmPassword){
        emit(state.copyWith(statusRegister: StatusRegister.failed,
            messageRegister: 'Mật khẩu không khớp'));
        return; }
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password);
      await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
        'uid': user.user?.uid,
        'email': event.email,
        'name': event.name,
        'password': event.password,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      emit(state.copyWith(statusRegister: StatusRegister.success,
          messageRegister: 'Đăng ký thành công'));
    }catch(e){
      emit(state.copyWith(statusRegister: StatusRegister.failed,
          messageRegister: 'Đăng ký thất bại: vui lòng kiểm tra lại'));
    }
  }
  void _sendEmail(SendEmail event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusSendEmail: StatusSendEmail.loading));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      emit(state.copyWith(statusSendEmail: StatusSendEmail.success,
          messageSend: 'Gửi email thành công'));
    }catch(e){
      emit(state.copyWith(statusSendEmail: StatusSendEmail.failed,
          messageSend: 'Gửi email thất bại'));
    }
  }
  void _loginFacebook(LoginFacebook event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusLogin: StatusLogin.loadingFb));
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(state.copyWith(statusLogin: StatusLogin.successFB,
          messageLogin: 'Đăng nhập thành công'));
    }catch(e){
      emit(state.copyWith(statusLogin: StatusLogin.failed,
          messageLogin: 'Đăng nhập thất bại'));
    }
  }
  void _loginGoogle(LoginGoogle event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusLogin: StatusLogin.loadingGG));
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? userAuth = await googleSignIn.signIn();
      if(userAuth == null){
        emit(state.copyWith(statusLogin: StatusLogin.failed,
            messageLogin: 'Đăng nhập thất bại'));
      }
      final authenticationUser = await userAuth!.authentication;
      final user = GoogleAuthProvider.credential(
        idToken: authenticationUser.idToken,
        accessToken: authenticationUser.accessToken
      );
      await FirebaseAuth.instance.signInWithCredential(user);
      emit(state.copyWith(statusLogin: StatusLogin.successGG,
          messageLogin: 'Đăng nhập thành công'));
    }catch(e){
      emit(state.copyWith(statusLogin: StatusLogin.failed,
          messageLogin: 'Đăng nhập thất bại'));
    }
  }
  void _logout(LogOutPage event, Emitter<LoginRegisterStates> emit) async {
    emit(state.copyWith(statusLogin: StatusLogin.loadingLogout));
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FacebookAuth facebookAuth = FacebookAuth.instance;
    try{
      try{
        await auth.signOut();
        print("Bạn đã đăng xuất rồi");
      }catch(e){
        print("Lỗi rồi $e");
      };
      try{
        await googleSignIn.signOut();
        print("Bạn đã đăng xuất rồi");
      }catch(e){
        print("Lỗi rồi $e");
      };
      try{
        await facebookAuth.logOut();
        print("Bạn đã đăng xuất rồi");
      }catch(e){
        print("Lỗi rồi $e");
      }
      emit(state.copyWith(user: null));
    }catch(e){}
  }
}
