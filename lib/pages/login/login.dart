import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/login/login_register_bloc.dart';
import '../home.dart';
import 'forget_pass.dart';

class Logins extends StatefulWidget {
  const Logins({super.key});

  @override
  State<Logins> createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  int selectedIndex = 0;
  late final StreamSubscription loginSubscription;

  @override
  void initState() {
    // TODO: implement initState
    context.read<LoginRegisterBloc>().add(LoginRegisterOrInitial());
    if(selectedIndex == 0){
      loginSubscription = context.read<LoginRegisterBloc>().stream.listen((state) {
        if (state.statusLogin == StatusLogin.success ||
            state.statusLogin == StatusLogin.successGuest ||
            state.statusLogin == StatusLogin.successGG ||
            state.statusLogin == StatusLogin.successFB) {
          Fluttertoast.showToast(
            msg: state.messageLogin,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
          );
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Home()),
            );
          }
        } else if (state.statusLogin == StatusLogin.failed) {
          Fluttertoast.showToast(
            msg: state.messageLogin,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
          );
        }
      });
    }
    super.initState();
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordLoinController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailLoginController.dispose();
    passwordLoinController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    loginSubscription.cancel();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  bool isEye = false;
  bool isEye1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff971132),
      body: BlocListener<LoginRegisterBloc, LoginRegisterStates>(
        listener: (context, state) {
         if(selectedIndex == 1){
           if(state.statusRegister == StatusRegister.success ){
             Fluttertoast.showToast(
               msg: state.messageRegister,
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.green,
             );
             emailController.text = '';
             passwordController.text = '';
             confirmPasswordController.text = '';
             nameController.text = '';
             setState(() {
             });
           } else if (state.statusRegister == StatusRegister.failed) {Fluttertoast.showToast(
             msg: state.messageRegister,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.red,
           );
           }
         }
        },
      child: BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
          builder: (context, state) {
            return Stack(
              children: [
                Image1Widget(),
                Image2Widget(),
                Positioned(
                  top: 145,
                  left: 20,
                  child: Container(
                    height: 588,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff971132).withAlpha(120),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  left: selectedIndex == 0 ? 0 : 135,
                                  top: 0,
                                  child: Container(
                                    width: 175,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xff971132),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      width: 155,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Đăng nhập",
                                        style: TextStyle(
                                          color: selectedIndex == 0 ? Colors.white : Color(0xff971132),
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 175,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      width: 125,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Đăng kí",
                                        style: TextStyle(
                                          color: selectedIndex == 1 ? Colors.white : Color(0xff971132),
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Form(
                            key: _formKey,
                              child: Column(
                            children: [
                              if(selectedIndex == 0)...[
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập email';
                                    }
                                    return null;
                                  },
                                  controller: emailLoginController,
                                  decoration: InputDecoration(
                                    hintText: "nhập Email",
                                    suffixIcon: Icon(Icons.email),
                                    suffixIconColor: Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập password';
                                    }
                                    return null;
                                  },
                                  obscureText: isEye ? false : true,
                                  controller: passwordLoinController,
                                  decoration: InputDecoration(
                                    hintText: "mật khẩu...",
                                    suffixIcon: IconButton(onPressed: () {
                                      setState(() {
                                        isEye = !isEye;
                                      });
                                    }, icon: isEye ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                                    suffixIconColor: isEye ? Colors.white : Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPass(),));
                                    },
                                    child: Text(
                                        "Quên mật khẩu?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ButtonLoginWidget(formKey: _formKey, emailLoginController: emailLoginController, passwordLoinController: passwordLoinController),
                                SizedBox(height: 20),
                                ButtonGuestWidget(),
                                SizedBox(height: 20),
                                Text("-----------------------",style: TextStyle(
                                  color: Colors.white
                                ),),
                                FaceBookOrGoogleWidget()
                              ],
                              if(selectedIndex == 1)...[
                                SizedBox(height: 15),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập tên';
                                    }
                                    return null;
                                  },
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "tên của bạn",
                                    suffixIcon: Icon(Icons.email),
                                    suffixIconColor: Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập email';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "nhập Email",
                                    suffixIcon: Icon(Icons.email),
                                    suffixIconColor: Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập password';
                                    }
                                    return null;
                                  },
                                  obscureText: isEye ? false : true,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: "mật khẩu...",
                                    suffixIcon: IconButton(onPressed: () {
                                      setState(() {
                                        isEye = !isEye;
                                      });
                                    }, icon: isEye ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                                    suffixIconColor: isEye ? Colors.white : Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập Confirm password';
                                    }
                                    return null;
                                  },
                                  obscureText: isEye1 ? false : true,
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    hintText: "nhập lại mật khẩu...",
                                    suffixIcon: IconButton(onPressed: () {
                                      setState(() {
                                        isEye1 = !isEye1;
                                      });
                                    }, icon: isEye1 ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                                    suffixIconColor: isEye1 ? Colors.white : Colors.white70,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 1.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70, width: 2),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                ButtonRegisterWidget(formKey: _formKey, emailController: emailController, passwordController: passwordController, confirmPasswordController: confirmPasswordController,nameController: nameController,),
                              ],
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ButtonRegisterWidget extends StatelessWidget {
  const ButtonRegisterWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginRegisterBloc>().add(RegisterPage(
                email: emailController.text,
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
                name: nameController.text,
              ));
            }
          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.redAccent.withAlpha(100)
            ),
            child: state.statusRegister == StatusRegister.loading ?
            Center(child:  SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))) : Center(
              child: Text("Đăng kí", style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
        );
      }
    );
  }
}

class FaceBookOrGoogleWidget extends StatelessWidget {
  const FaceBookOrGoogleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: () {
          context.read<LoginRegisterBloc>().add(LoginFacebook());
        }, icon: Icon(Icons.facebook_sharp,color: Colors.blueAccent,size: 55,)),
        Text("Or",style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),),
        SizedBox(width: 10,),
        GestureDetector(
          onTap: () {
            context.read<LoginRegisterBloc>().add(LoginGoogle());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset('assets/images/google.png',height: 50,
            width: 50,),
          ),
        )
      ],
    );
  }
}

class ButtonGuestWidget extends StatelessWidget {
  const ButtonGuestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
      builder: (context, state) {
        return
          GestureDetector(
            onTap: () {
              context.read<LoginRegisterBloc>().add(LoginBot());
            },
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              child: state.statusLogin == StatusLogin.loadingGuest ?
              Center(child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))) : Center(
                child: Text("Khách", style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
          );
      }
    );
  }
}

class ButtonLoginWidget extends StatelessWidget {
  const ButtonLoginWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailLoginController,
    required this.passwordLoinController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController emailLoginController;
  final TextEditingController passwordLoinController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if(_formKey.currentState!.validate()){
              context.read<LoginRegisterBloc>().add(LoginPage(
                email: emailLoginController.text,
                password: passwordLoinController.text,
              ));
            }
          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.redAccent.withAlpha(100)
            ),
            child: state.statusLogin == StatusLogin.loading ?
            Center(child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))) : Center(
              child: Text("Đăng nhập",style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
        );
      },
    );
  }
}

class Image2Widget extends StatelessWidget {
  const Image2Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 617,
      left: 152,
      child: Image.asset(
        "assets/images/2.png",
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}

class Image1Widget extends StatelessWidget {
  const Image1Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      left: -65,
      child: Image.asset(
        "assets/images/1.png",
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
