import 'package:app_test/navigation_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/api/api_bloc.dart';
import '../models/api_model.dart';
import '../models/hive_meal.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.meal, this.mealHive});

  final Meals meal;
  final MealHive? mealHive;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavourite;
  @override
  void initState() {
    // TODO: implement initState
    context.read<ApiBloc>().add(FetchApi());
    final box = Hive.box<MealHive>('favourite');
    isFavourite = box.values.any((m) => m.strMeal == widget.meal.strMeal);
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<ApiBloc, ApiStates>(
        builder: (context, state) {
          List<String> allIngredients = [];
          for (var i = 0; i < 21; i++) {
            final ingredients = (widget.meal.toJson()['strIngredient$i'] ?? '')
                .toString()
                .trim();
            final measures = (widget.meal.toJson()['strMeasure$i'] ?? '')
                .toString()
                .trim();
            if (ingredients.isNotEmpty) {
              allIngredients.add('$ingredients - $measures');
            }
            if(ingredients.isEmpty && measures.isEmpty && i == 1){
              allIngredients.add('Xin lỗi món này hiện tại đang hoàn thiện nguyên liệu nên bạn hãy xem món khác nhé');
            }
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: "assets/images/loading.png",
                      image: widget.meal.strMealThumb ?? '',
                      height: size.height * 0.35,
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 30,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBottomNav(),));
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Chi Tiết",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                ListItemWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Món: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.meal.strMeal ?? '',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.meal.strInstructions ??
                                  'Hãy xem nguyên liệu và cách chế bién bên dưới ^^',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final box = Hive.box<MealHive>('favourite');

                          if (isFavourite) {
                            final items = box.values.where((m) => m.idMeal == widget.meal.idMeal).toList();
                            if (items.isNotEmpty) items.first.delete();
                          } else {
                            // Thêm vào Hive (có idMeal)
                            final mealHive = MealHive(
                              idMeal: widget.meal.idMeal ?? '',
                              strMeal: widget.meal.strMeal ?? '',
                              strMealThumb: widget.meal.strMealThumb ?? '',
                            );
                            box.add(mealHive);
                          }
                          setState(() {
                            isFavourite = !isFavourite;
                          });
                        },
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                FiveStar(),
                ImageAndName(),
                Divider(
                  color: Colors.amber,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? Colors.amber
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Nguyên liệu",
                            style: TextStyle(
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? Colors.amber
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Chế biến",
                            style: TextStyle(
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                state.status == StatusFetch.loading
                    ? Center(child: CircularProgressIndicator())
                    : selectedIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dành cho 2-4 người ăn:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: allIngredients.length,
                              itemBuilder: (context, index) {
                                final ingredient = allIngredients[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    ingredient == null || ingredient.isEmpty
                                        ? 'Xin lỗi món này hiện tại đang hoàn thiện nguyên liệu nên bạn hãy xem món khác nhé'
                                        : ingredient,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  final url = widget.meal.strYoutube;
                                  if (url != null) {
                                    launchUrl(Uri.parse(url));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Không có video")),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 60,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.video_call_outlined,
                                        color: Colors.amber,
                                        size: 30,
                                      ),
                                      Text(
                                        "Xem video",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      )
                    : SizedBox(),
                selectedIndex == 1
                    ? state.status == StatusFetch.loading
                          ? Center(child: CircularProgressIndicator())
                          : (Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 20,
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cách chế biến chi tiết:",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    widget.meal.strInstructions ??
                                        'Xin lỗi món này hiện tại đang hoàn thiện cách chế biến mới nên bạn hãy xem món khác nhé',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                    : SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ImageAndName extends StatelessWidget {
  const ImageAndName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Image.asset(
              "assets/images/nguoi.jpg",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "Trần Đức Tuấn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class FiveStar extends StatelessWidget {
  const FiveStar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text(' ⭐ 5', style: TextStyle(fontSize: 18)),
          Container(
            height: 20,
            margin: EdgeInsets.only(left: 20, right: 20),
            width: 3,
            color: Colors.grey,
          ),
          Text('120 đánh giá', style: TextStyle(fontSize: 13,
          color: Colors.grey)),
          GestureDetector(
            onTap: () {
             Fluttertoast.showToast(
                 msg: "Chưa xử lý",
                 toastLength: Toast.LENGTH_SHORT,
                 gravity: ToastGravity.BOTTOM,
                 timeInSecForIosWeb: 1,
             backgroundColor: Colors.redAccent,
             fontAsset: 'assets/images/nguoi.jpg');
            },
            child: Container(
              height: 35,
              margin: EdgeInsets.only(left: 60, right: 20),
              width: 90,
              color: Colors.black,
              child:  Center(
                child: Text('Đặt ngay', style: TextStyle(fontSize: 13,
                    color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc,ApiStates>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: ListView.builder(
            itemCount: state.meals.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final meal = state.meals[index];
              return GestureDetector(
                onTap: () {
                  final box = Hive.box<MealHive>('favourite');
                  MealHive? mealHive;
                  if (box.containsKey(meal.strMealThumb)) {
                    mealHive = box.get(meal.strMealThumb);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(
                            meal: meal,
                            mealHive: mealHive,
                          ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.png',
                      image: "${meal.strMealThumb}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
