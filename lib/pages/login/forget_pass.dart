import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/login/login_register_bloc.dart';
import '../home.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff971132),
      body: BlocListener<LoginRegisterBloc, LoginRegisterStates>(
        listener: (context, state) {
          if (state.statusSendEmail == StatusSendEmail.success) {
            Fluttertoast.showToast(
              msg: state.messageSend,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
            );
          } else if (state.statusSendEmail == StatusSendEmail.failed) {
            Fluttertoast.showToast(
              msg: state.messageSend,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
            );
          }
        },
        child: BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
          builder: (context, state) {
            return Stack(
              children: [
                Image1Widget(),
                Image2Widget(),
                TextfieldOrButton(formKey: _formKey, emailController: emailController),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TextfieldOrButton extends StatelessWidget {
  const TextfieldOrButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
      builder: (context, state) {
        return Positioned(
          top: 205,
          left: 20,
          child: Container(
            height: 388,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff971132).withAlpha(120),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(onPressed: () {
                      Navigator.pop(context);
                    },
                        icon: Icon(
                          Icons.arrow_back, color: Colors.white, size: 30,)),
                  ),
                  Icon(Icons.email, size: 100,
                    color: Colors.white70,),
                  Form(
                      key: _formKey,
                      child: Column(
                          children: [
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
                                hintText: "Enter Email",
                                suffixIcon: Icon(Icons.email),
                                suffixIconColor: Colors.white70,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 1.5),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginRegisterBloc>().add(
                                      SendEmail(email: emailController.text));
                                }
                              },
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.redAccent.withAlpha(100)
                                ),
                                child: state.statusSendEmail ==
                                    StatusSendEmail.loading
                                    ?
                                Center(child: CircularProgressIndicator())
                                    : Center(
                                  child: Text("Gửi", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                              ),
                            ),
                          ]
                      ))
                ],
              ),
            ),
          ),
        );
      }
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
