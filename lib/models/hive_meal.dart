import 'package:hive/hive.dart';
part 'hive_meal.g.dart';

@HiveType(typeId: 0) // nếu thay đổi field mà ko muốn migrate -> xoá box cũ
class MealHive extends HiveObject {
  @HiveField(0)
  final String idMeal;

  @HiveField(1)
  final String strMeal;

  @HiveField(2)
  final String strMealThumb;

  MealHive({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory MealHive.fromJson(Map<String, dynamic> json) {
    return MealHive(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
    );
  }
}
