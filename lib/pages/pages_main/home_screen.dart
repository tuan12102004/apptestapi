import 'package:app_test/pages/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/api/api_bloc.dart';
import '../../models/api_model.dart';
import '../View_all_categories.dart';
import '../watch_all_videos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ApiBloc>().add(FetchApiTextD());
    context.read<ApiBloc>().add(FetchApi());
    context.read<ApiBloc>().add(ChooseCategory(category: 'Beef'));
    selectedIndex = categories.indexOf('Beef');
    context.read<ApiBloc>().add(Ingredient(category: 'Chicken'));
    ingredientIndex = ingredients.indexOf('Chicken');
    context.read<ApiBloc>().loadFavourite();
    super.initState();
  }

  late List<Meals> allMeals;
  late List<Meals> categoryMeals;
  TextEditingController searchController = TextEditingController();
  int? selectedIndex;
  int? ingredientIndex;
  List<String> categories = [
    'Beef',
    'Chicken',
    'Seafood',
    'Dessert',
    'Vegetarian',
    'Vegan',
    'Lamb',
    'Pork',
    'Miscellaneous',
    'Starter',
    'Goat',
  ];
  List<String> ingredients = [
    'Chicken',
    'Beef',
    'Salmon',
    'Tuna',
    'Onion',
    'Garlic',
    'Salt',
    'Pepper',
    'Sugar',
    'Flour',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ApiBloc, ApiStates>(
          builder: (context, state) {
            if (state.status == StatusFetch.loading) {
              return Center(child: CircularProgressIndicator());
            }
             return Column(
               children: [
                 buildSearchBox(size: size, searchController: searchController),
                 SizedBox(height: 10),
                 if (searchController.text.isNotEmpty)
                   buildItemSearch(size: size) else
                 Expanded(
                   child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          buildCityHeader(),
                          SizedBox(height: 10),
                          buildHorizontalMeals(),
                          buildCategories(),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    context.read<ApiBloc>().add(
                                      ChooseCategory(category: categories[index]),
                                    );
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 30,
                                        margin: EdgeInsets.only(
                                          left: 20,
                                          top: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index
                                              ? Color(0xffCEA700)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: selectedIndex == index
                                                ? Color(0xffCEA700)
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            categories[index],
                                            style: TextStyle(
                                              color: selectedIndex == index ? Colors.white : Colors.black,
                                              fontSize: 15,
                                              fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.mealsChoose.length,
                              itemBuilder: (context, index) {
                                final meal = state.mealsChoose[index];
                                return Stack(
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(meal: meal,),));
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 180,
                                            margin: EdgeInsets.only(
                                              left: 20,
                                              top: 40,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                              color: Colors.amber.withAlpha(80),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 50,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    meal.strMeal ?? '',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xffCEA700),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text('Tạo Bời:'),
                                                  Text(
                                                    'Trần Đức Tuấn',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xffCEA700),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30, width: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        "20 phút",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black45,
                                                        ),
                                                      ),
                                                      Icon(Icons.notes_outlined),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      left: 45,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(meal: meal,),));
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/images/loading.png",
                                            image: "${meal.strMealThumb}",
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.contain,)),
                                      )
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          buildRecentMeals(),
                          BlocBuilder<ApiBloc, ApiStates>(
                            builder: (context, state) {
                              if (state.status == StatusFetch.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state.status == StatusFetch.error) {
                                return Text("Error: ${state.message}");
                              }
                              if (state.mealsT.isEmpty) {
                                return const Text("No meals found");
                              }
                              return SizedBox(
                                height: 240,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.mealsSelectedIngredient.length,
                                  itemBuilder: (context, index) {
                                    final meal = state.mealsSelectedIngredient[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 28.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(meal: meal,),));
                                        },
                                        child: SizedBox(
                                          width: 160,
                                          height: 250,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                  10,
                                                ),
                                                child: FadeInImage.assetNetwork(
                                                    placeholder: "assets/images/loading.png",
                                                    image: "${meal.strMealThumb}",width: 160,
                                                    height: 160,
                                              ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                meal.strMeal ?? 'lỗi',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffCEA700),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16,
                                                    backgroundImage: AssetImage(
                                                      "assets/images/nguoi.jpg",
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Trần Đức Tuấn",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          buildIngredients(),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 20),
                            child: SizedBox(
                              height: 100,
                              child: GridView.builder(
                                itemCount: ingredients.length,
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 1 / 1.8,
                                    ),
                                itemBuilder: (context, index) {
                                  final meal = ingredients[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        ingredientIndex = index;
                                      });
                                      context.read<ApiBloc>().add(
                                        Ingredient(category: ingredients[index]),
                                      );
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: ingredientIndex == index
                                            ? Color(0xffCEA700)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: ingredientIndex == index
                                              ? Color(0xffCEA700)
                                              : Colors.grey,
                                          width: 1,
                                        )
                                      ),
                                      child: Center(child: Text(
                                          meal.toString(),style: TextStyle(
                                        color: ingredientIndex == index ? Colors.white : Colors.black,
                                        fontSize: 15,
                                        fontWeight: ingredientIndex == index ? FontWeight.bold : FontWeight.normal,
                                      ),)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                 )]);
                }
        ),
      ),
    );
  }
}

class buildItemSearch extends StatelessWidget {
  const buildItemSearch({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc,ApiStates>(
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: state.mealsSearch.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final meal = state.mealsSearch[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(meal: meal,),));
                },
                child: SizedBox(
                  width: size.width * 0.9,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      children: [
                        Row(
                            children: [
                              Expanded(
                                child: Text(meal.strMeal ?? '',style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              Icon(Icons.arrow_forward_ios,size: 20,color: Colors.amber,)
                            ]
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class buildIngredients extends StatelessWidget {
  const buildIngredients({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        "Nguyên Liệu",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class buildRecentMeals extends StatelessWidget {
  const buildRecentMeals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        bottom: 30,
      ),
      child: Text(
        "Công thức gần đây",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class buildCategories extends StatelessWidget {
  const buildCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Danh mục",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllCategories(),));
            },
            child: Text(
              "Xem tất cả",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffCEA700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class buildHorizontalMeals extends StatelessWidget {
  const buildHorizontalMeals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiBloc, ApiStates>(
      builder: (context, state) {
        final meals = state.meals;
        if (meals.isEmpty) {
          // Skeleton loading: 5 placeholder items
          return SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: 240,
                      height: 270,
                      margin: EdgeInsets.only(left: 20),
                      child: Stack(
                        children: [
                          // Ảnh placeholder
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/loading.png',
                              height: 140,
                              width: 216,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 150),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 13,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: 120,
                                  height: 17,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                      AssetImage("assets/images/nguoi.jpg"),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 80,
                                      height: 15,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return Column(
                children: [
                  Container(
                    width: 240,
                    height: 270,
                    margin: EdgeInsets.only(left: 20),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ảnh món ăn với placeholder
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/loading.png',
                                      height: 140,
                                      width: 216,
                                      fit: BoxFit.cover,
                                    ),
                                    if (meal.strMealThumb != null)
                                      Image.network(
                                        meal.strMealThumb!,
                                        height: 140,
                                        width: 216,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return SizedBox(); // vẫn hiện placeholder
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return SizedBox();
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              // Thời gian nấu
                              Text(
                                '1 tiếng 20 phút',
                                style: TextStyle(
                                  color: Color(0xff0043B3),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Tên món ăn
                              Text(
                                meal.strMeal ?? '',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontStyle: FontStyle.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              // Avatar + tên người
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage("assets/images/nguoi.jpg"),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Trần Đức Tuấn",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffCEA700),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Star box
                        Positioned(
                          top: 20,
                          left: 10,
                          child: Container(
                            width: 50,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 18),
                                  SizedBox(width: 10),
                                  Text(
                                    "5",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Play button
                        Positioned(
                          top: 40,
                          left: 90,
                          child: GestureDetector(
                            onTap: () async {
                              if (meal.strYoutube != null && meal.strYoutube!.isNotEmpty) {
                                final Uri uri = Uri.parse(meal.strYoutube!);
                                try {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  print('Không mở được link');
                                }
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
class buildCityHeader extends StatelessWidget {
  const buildCityHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "TP.Hồ Chí Minh",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WatchAllVideos(),));
            },
            child: Text(
              "Xem tất cả",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffCEA700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class buildSearchBox extends StatelessWidget {
  const buildSearchBox({
    super.key,
    required this.size,
    required this.searchController,
  });

  final Size size;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      height: 50,
      margin: EdgeInsets.fromLTRB(8, 7, 8, 7),
      padding: EdgeInsets.fromLTRB(8, 7, 8, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<ApiBloc>().add(Search(value));
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
