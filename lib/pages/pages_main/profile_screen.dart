import 'package:app_test/bloc/login/login_register_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/api_model.dart';
import '../../models/hive_meal.dart';
import '../detail_screen.dart';
import '../login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            final doc = snapshot.data;
            if (doc == null || !doc.exists) {
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Xin lỗi hiện tại này em chưa học"),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Đăng xuất"),
                    onTap: () {
                      context.read<LoginRegisterBloc>().add(LogOutPage());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Logins(),));
                    },
                  ),
                ],
              ));
            }
            final data = doc.data() as Map<String, dynamic>;
            return BlocBuilder<LoginRegisterBloc, LoginRegisterStates>(
              builder: (context, state) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blueAccent.shade100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chào bạn: ${data['name']}",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Email: ${data['email']}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: state.statusLogin == StatusLogin.loadingLogout ? Center(child: CircularProgressIndicator(
                        color: Colors.white,
                      )) : Text("Đăng xuất"),
                      onTap: () {
                        context.read<LoginRegisterBloc>().add(LogOutPage());
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Logins(),));
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

      appBar: AppBar(
        title: Text('Trang cá nhân'),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(40),
                  child: Image.asset(
                    "assets/images/nguoi.jpg",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Trần Đức Tuấn",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NewsWidget(text: "Bài viết", number: "100"),
                  Container(
                    width: 3,
                    height: 40,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    color: Colors.grey,
                  ),
                  NewsWidget(text: "Người Theo Dõi", number: "100"),
                  Container(
                    width: 3,
                    height: 40,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    color: Colors.grey,
                  ),
                  NewsWidget(text: "Theo Dõi", number: "100"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Follow",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Message",
                        style: TextStyle(fontSize: 20, color: Colors.amber),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Danh sách yêu thích",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              FutureBuilder<Box<MealHive>>(
                future: Hive.openBox<MealHive>("favourite"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final box = snapshot.data!;
                  return ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (context, value, child) {
                      return GridView.builder(
                        itemCount: box.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8 / 0.8,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final image = box.getAt(index) as MealHive;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    mealHive: MealHive(
                                      idMeal: image.idMeal ?? '',
                                      // 👈 cần truyền idMeal
                                      strMeal: image.strMeal ?? '',
                                      strMealThumb: image.strMealThumb ?? '',
                                    ),
                                    meal: Meals(
                                      idMeal: image.idMeal,
                                      strMeal: image.strMeal,
                                      strMealThumb: image.strMealThumb,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loading.png',
                                image: image.strMealThumb.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key, required this.text, required this.number});

  final String text;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          number,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
