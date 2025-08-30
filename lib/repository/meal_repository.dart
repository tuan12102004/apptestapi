import 'package:cloudinary/cloudinary.dart';

import '../models/api_model.dart';

class MealRepository {
  Future<List<Meals>> fetch() async {
    final Dio dio = Dio();
    List<Meals> allMeals = [];
    try {
      for (var c in 'bcdefgh'.split('')) {
        final response = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/search.php?f=$c',
        );
        final apiModel = ApiModel.fromJson(response.data);
        if (apiModel.meals != null) {
          allMeals.addAll(apiModel.meals!);
        }
      }
    } catch (e) {
      print(e);
    }
    return allMeals;
  }
}