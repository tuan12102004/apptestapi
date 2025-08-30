import 'package:app_test/navigation_bottom.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
            Image.asset("assets/images/anh.jpg",fit: BoxFit.cover,height: size.height,),
            Positioned(
              bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height * 0.2,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                    gradient: LinearGradient(colors: [
                      Color(0x0fffffff),
                      Color(0xFF000000).withOpacity(0.7),
                      Color(0xFF000000).withOpacity(1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,)
                  ),
                )),
            Positioned(
              bottom: 150,
              left: 70,
              right: 40,
              child: Text("Bắt đầu với những món ăn",style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
                textAlign: TextAlign.center,)),
            Positioned(
            bottom: 100,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBottomNav()));
              },
              child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Color(0xffCEA700),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Bắt đầu ",style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      ),
                      Icon(Icons.arrow_forward,color: Colors.white,)
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
