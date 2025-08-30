import 'package:app_test/bloc/api/api_bloc.dart';
import 'package:app_test/models/api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ApiBloc>().add(ChooseIngredientsOrAreaOrCategory(
        category: "Miscellaneous",
        ingredients: "Spanish",
        area: "Bread"));
    super.initState();
  }
  final TextEditingController searchController = TextEditingController();
  bool showContainer = false;
  int? currentIndex;
  int? currentIndex1;
  int? currentIndex2;
  final List<String> category = [
    "Miscellaneous",
    "Seafood",
    "Side",
    "Vegetarian",
    "Beef",
  ];
  final List<String> area = [
    "Spanish",
    "Japanese",
    "Croatian",
    "Turkish",
    "Egyptian",
  ];
  final List<String> ingredients = [
    "Bread",
    "Olive Oil",
    "Garlic",
    "Pork",
    "Sushi Rice",
  ];
  _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lọc",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            setState(() {
                              currentIndex = null;
                              currentIndex1 = null;
                              currentIndex2 = null;
                            });
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xffCEA70026).withAlpha(15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Đặt lại",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.book_online, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Danh mục",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: category.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / 2.5,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = currentIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {   // <-- dùng setModalState để cập nhật modal
                              currentIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                category[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.category, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Nguyên liệu",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ingredients.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / 2.5,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = currentIndex1 == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              currentIndex1 = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                ingredients[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Khu vực",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: area.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / 2.5,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = currentIndex2 == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              currentIndex2 = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                area[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (currentIndex == null || currentIndex1 == null || currentIndex2 == null) {
                        Fluttertoast.showToast(msg: 'Vui lòng chọn đủ cả 3',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        return;
                      }
                      String category = this.category[currentIndex!];
                      String ingredients = this.ingredients[currentIndex1!];
                      String area = this.area[currentIndex2!];
                      context.read<ApiBloc>().add(
                        ChooseIngredientsOrAreaOrCategory(
                          category: category,
                          ingredients: ingredients,
                          area: area,
                        ),
                      );
                      Navigator.pop(context);
                      setModalState(() {
                        currentIndex = null;
                        currentIndex1 = null;
                        currentIndex2 = null;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Xác nhận",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Khoảng cách dưới cùng
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SearchWidget(
                    size: size,
                    searchController: searchController,
                    onFilterTap: () => _showFilterSheet(context),
                  ),
                  BlocListener<ApiBloc, ApiStates>(
                    listener: (context, state) {
                      if (state.status == StatusFetch.error) {
                        Center(child: Text("Hiện tại không có món bạn tìm"));
                      }
                    },
                    child: BlocBuilder<ApiBloc, ApiStates>(
                      builder: (context, state) {
                        if (state.status == StatusFetch.loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return SizedBox(
                          height: size.height,
                          width: size.width,
                          child: GridView.builder(
                            itemCount: state.mealsSearch.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.9 / 1.3,
                            ),
                            itemBuilder: (context, index) {
                             final meal = state.mealsSearch[index];
                             bool isFavourite = state.favourite
                                 .any((element) => element.strMeal == meal.strMeal);
                             return GridItemSearch(meal: meal, isFavourite: isFavourite);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItemSearch extends StatelessWidget {
  const GridItemSearch({
    super.key,
    required this.meal,
    required this.isFavourite,
  });

  final Meals meal;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(meal: meal)));},
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: meal.strMealThumb != null &&
                    meal.strMealThumb!.isNotEmpty
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.png',
                      image: meal.strMealThumb!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 170,
                    )
                )
                    : Icon(Icons.image, size: 100),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(170),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () {
                    if (isFavourite) {
                      context
                          .read<ApiBloc>()
                          .add(RemoveFavourite(meal: meal));
                    } else {
                      context
                          .read<ApiBloc>()
                          .add(AddFavourite(meal: meal));
                    }
                  },
                  icon: Icon(
                    isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          meal.strMeal ?? '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'By Little Pony',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
            ),
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    size: 20, color: Colors.amber),
                SizedBox(width: 5),
                Text(
                  '20m',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
class SearchWidget extends StatelessWidget {
  final Size size;
  final TextEditingController searchController;
  final VoidCallback onFilterTap;

  const SearchWidget({
    super.key,
    required this.size,
    required this.searchController,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 45,
            width: size.width * 0.72,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<ApiBloc>().add(Search(value));
              },
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: onFilterTap,
            icon: Icon(Icons.filter_alt_sharp, color: Colors.amber, size: 40),
          ),
        ],
      ),
    );
  }
}
