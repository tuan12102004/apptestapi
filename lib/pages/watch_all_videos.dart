import 'package:app_test/bloc/api/api_bloc.dart';
import 'package:app_test/models/api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchAllVideos extends StatefulWidget {
  const WatchAllVideos({super.key});

  @override
  State<WatchAllVideos> createState() => _WatchAllVideosState();
}

class _WatchAllVideosState extends State<WatchAllVideos> {
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
        title: Text('Xem tất cả video',style: TextStyle(
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
                                    Expanded(
                                      child: Text(meal.strMeal.toString(),style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
