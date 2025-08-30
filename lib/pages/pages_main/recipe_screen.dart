import 'package:app_test/bloc/api/api_bloc.dart';
import 'package:app_test/models/api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ApiBloc>().add(FetchApi());
    super.initState();
  }
  int currentIndex = 0;
  Set<int> expandedIndex = {};
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Công thức',style: TextStyle(
          color: Colors.amber.shade700,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back,color: Colors.amber,size: 30,)),
      ),
      body: BlocBuilder<ApiBloc,ApiStates>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 180,
                          decoration: BoxDecoration(
                            color:currentIndex == 0? Colors.amber : Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Video",style: TextStyle(
                                color: currentIndex == 0 ? Colors.white : Colors.amberAccent,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 180,
                          decoration: BoxDecoration(
                            color:currentIndex == 1? Colors.amber : Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Công thức",style: TextStyle(
                                color: currentIndex == 1 ? Colors.white : Colors.amberAccent,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  if( currentIndex == 0)...[
                    ListView.builder(
                      itemCount: state.meals.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                       final meal = state.meals[index];
                       bool isFavourite = state.favourite.any((element) => element.strMealThumb == meal.strMealThumb,);
                       return Container(
                         margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(
                               height: 190,
                               child: Stack(
                                 children: [
                                   Positioned(
                                     top: 20,
                                     left: 20,
                                     right: 20,
                                     child: ClipRRect(
                                       borderRadius: BorderRadiusGeometry.circular(20),
                                       child: FadeInImage.assetNetwork(
                                           placeholder: 'assets/images/loading.png',
                                           image: meal.strMealThumb.toString() ?? '',
                                       fit: BoxFit.cover,height: 160,),
                                     )),
                                   Positioned(
                                       top: 70,
                                       left: 160,
                                       child: GestureDetector(
                                         onTap: () {
                                           launchUrl(Uri.parse(meal.strYoutube.toString()));
                                         },
                                         child: Container(
                                           height: 70,
                                           width: 70,
                                           decoration: BoxDecoration(
                                             color: Colors.white60,
                                             borderRadius: BorderRadius.circular(40),
                                           ),
                                           child: Icon(Icons.play_arrow,color: Colors.white,size: 40,),
                                           ),
                                       ),
                                       )
                                 ],
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text("1 tiếng 20 phút",style: TextStyle(
                                     fontSize: 15,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.blueAccent
                                   ),),
                                   IconButton(
                                       onPressed: () {
                                         if(isFavourite){
                                           context.read<ApiBloc>().add(RemoveFavourite(meal: meal));
                                         } else {
                                           context.read<ApiBloc>().add(AddFavourite(meal: meal));
                                         }
                                       },
                                       icon: isFavourite ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border,color: Colors.black,)),
                                 ],
                               ),
                               ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
                               child: Text(meal.strInstructions.toString(),style: TextStyle(
                                 fontSize: 14,
                                 color: Colors.grey
                               ),
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                             )),
                             SizedBox(height: 10,),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
                               child: Row(
                                 children: [
                                   ClipRRect(
                                     borderRadius: BorderRadiusGeometry.circular(30),
                                     child: Image.asset(
                                       "assets/images/nguoi.jpg",
                                       width: 60,
                                       height: 60,)
                                   ),
                                   SizedBox(width: 10,),
                                   Text("Trần Đức Tuấn",style: TextStyle(
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.amber))
                                 ],
                               ),
                             )
                           ],
                         ),
                       );
                      },)
                  ],
                  if( currentIndex == 1)...[
                    ListView.builder(
                      itemCount: state.meals.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                       final meal = state.meals[index];
                       bool isFavourite = state.favourite.any((element) => element.strMealThumb == meal.strMealThumb,);
                       return GestureDetector(
                         onTap: () {
                           setState(() {
                             if(expandedIndex.contains(index)){
                               expandedIndex.remove(index);
                             } else {
                               expandedIndex.add(index);
                             }
                           });
                         },
                         child: AnimatedContainer(
                           duration: Duration(milliseconds: 300),
                           margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
                          height: expandedIndex.contains(index) ? size.height * 0.47 : 200,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                           child: Stack(
                             children: [
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   SizedBox(
                                     height: 120,
                                     width: size.width * 0.8,
                                     child: Row(
                                       children: [
                                         ClipRRect(
                                           borderRadius: BorderRadiusGeometry.circular(20),
                                           child: FadeInImage.assetNetwork(
                                               placeholder: 'assets/images/loading.png',
                                               image: meal.strMealThumb.toString() ?? '',
                                           fit: BoxFit.cover,height: 60,width: 60,),
                                         ),
                                         SizedBox(width: 10),
                                         Padding(
                                           padding: const EdgeInsets.only(top: 28.0),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Row(
                                                 children: [
                                                   Text("Món: "),
                                                   SizedBox(
                                                     width: 200,
                                                     height: 20,
                                                     child: Text(meal.strMeal.toString(),style: TextStyle(
                                                       fontSize: 18,
                                                       fontWeight: FontWeight.bold,
                                                     ), overflow: TextOverflow.ellipsis,
                                                       maxLines: 1,),
                                                   ),
                                                 ],
                                               ),
                                               Row(
                                                 children: [
                                                   Text("Loại: "),
                                                   Text(meal.strCategory.toString(),style: TextStyle(
                                                     fontSize: 15,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.grey
                                                   ), overflow: TextOverflow.ellipsis,
                                                     maxLines: 1,),
                                                 ],
                                               ),
                                               Row(
                                                 children: [
                                                   Text("Khu vực: "),
                                                   Text(meal.strArea.toString(),style: TextStyle(
                                                       fontSize: 15,
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.grey
                                                   ),
                                                   overflow: TextOverflow.ellipsis,
                                                   maxLines: 1,),
                                                 ],
                                               ),
                                             ]
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   Text("Cách chế biến: ",),
                                   Expanded(
                                     child: Text("${meal.strInstructions}",style: TextStyle(
                                       fontSize: 14,
                                       color: Colors.grey,
                                     ),
                                     maxLines: expandedIndex.contains(index) ? 10 : 3,
                                         overflow: TextOverflow.ellipsis,),
                                   )
                                 ],
                               ),
                               IconButtonFav(isFavourite: isFavourite, meal: meal)
                             ],
                           ),
                         ),
                       );
                      },)
                  ],
                ]
            ),
          );
        },
      ),
    );
  }
}

class IconButtonFav extends StatelessWidget {
  const IconButtonFav({
    super.key,
    required this.isFavourite,
    required this.meal,
  });

  final bool isFavourite;
  final Meals meal;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
        top: 20,
        child: GestureDetector(
          onTap: () {
            if(isFavourite){
              context.read<ApiBloc>().add(RemoveFavourite(meal: meal));
            } else {
              context.read<ApiBloc>().add(AddFavourite(meal: meal));
            }
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(isFavourite ? Icons.favorite : Icons.favorite_border,color: Colors.red,size: 40,),
          ),
        ));
  }
}
