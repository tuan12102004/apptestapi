import 'package:app_test/bloc/login/login_register_bloc.dart';
import 'package:app_test/pages/home.dart';
import 'package:app_test/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'bloc/api/api_bloc.dart';
import 'firebase_options.dart';
import 'models/hive_meal.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(MealHiveAdapter());
  await Hive.openBox<MealHive>('favourite');
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ApiBloc()),
            BlocProvider(create: (context) => LoginRegisterBloc()),
          ],
          child: MaterialApp(
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Home();
                } else {
                  return Logins();
                }
              },
            ),
            debugShowCheckedModeBanner: false,
          )
      ));
}
