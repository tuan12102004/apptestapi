import 'package:app_test/bloc/api/api_bloc.dart';
import 'package:app_test/models/api_model.dart';
import 'package:app_test/pages/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAllCategories extends StatefulWidget {
  const ViewAllCategories({super.key});

  @override
  State<ViewAllCategories> createState() => _ViewAllCategoriesState();
}

class _ViewAllCategoriesState extends State<ViewAllCategories> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ApiBloc>().add(FetchApi());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem tất cả',style: TextStyle(
            color: Colors.amber.shade700,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: Colors.amber,size: 30,)),
      ),
      body: BlocBuilder<ApiBloc,ApiStates>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 20,),
                  ListView.builder(
                    itemCount: state.meals.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final meal = state.meals[index];
                      return Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadiusGeometry.circular(20),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/loading.png',
                                          image: meal.strMealThumb.toString() ?? '',
                                          fit: BoxFit.cover,height: 80,width: 80,),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Tên: "),
                                          SizedBox(
                                            width: 200,
                                            child: Text(meal.strMeal.toString(),style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold
                                            ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Loại: ",style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          ),),
                                          Text(meal.strCategory.toString(),style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          SizedBox(width: 10,),
                                          Text("Thể loại: ",style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          ),),
                                          SizedBox(
                                            width: 40,
                                            child: Text((meal.strTags?.isEmpty == true || meal.strTags == null) ? 'Ask' : meal.strTags.toString(),style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Khu Vực: ",style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          ),),
                                          Text( meal.strArea.toString(),style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          SizedBox(width: 10,),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Thời gian chế bién: ",style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black
                                          ),),
                                          Text("120 phút",style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold
                                          ),)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 0,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(meal: meal)));
                                  },
                                  icon: Icon(Icons.arrow_forward))
                            )
                          ],
                        ),
                      );
                    },)
                ]
            ),
          );
        },
      ),
    );
  }
}
