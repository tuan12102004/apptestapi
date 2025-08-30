part of 'api_bloc.dart';

enum StatusFetch { loading, success, error }

class ApiStates extends Equatable {
  final StatusFetch status;
  final String message;
  final List<Meals> meals;
  final List<Meals> mealsT;
  final List<Meals> mealsSearch;
  final List<Meals> mealsStrInstructions;
  final List<String> mealsPrices;
  final List<Meals> mealsChoose;
  final List<Meals> mealsSelectedIngredient;
  final List<String> mealsStrIngredient;
  final List<MealHive> favourite;
  const ApiStates({
    this.status = StatusFetch.loading,
    this.mealsSelectedIngredient = const [],
    this.mealsStrIngredient = const [],
    this.mealsPrices = const [],
    this.favourite = const [],
    this.mealsStrInstructions = const [],
    this.mealsT = const [],
    this.message = '',
    this.meals = const [],
    this.mealsSearch = const [],
    this.mealsChoose = const [],
  });

  ApiStates copyWith({
    StatusFetch? status,
    List<MealHive>? favourite,
    List<String>? mealsPrices,
    List<Meals>? mealsDetail,
    String? message,
    List<Meals>? mealsStrInstructions,
    List<Meals>? meals,
    List<Meals>? mealsT,
    List<Meals>? mealsSearch,
    List<Meals>? mealsChoose,
    List<Meals>? mealsSelectedIngredient,
    List<String>? mealsStrIngredient,
  }) {
    return ApiStates(
      status: status ?? this.status,
      message: message ?? this.message,
      mealsSelectedIngredient: mealsSelectedIngredient ?? this.mealsSelectedIngredient,
      mealsStrIngredient: mealsStrIngredient ?? this.mealsStrIngredient,
      mealsPrices: mealsPrices ?? this.mealsPrices,
      mealsT: mealsT ?? this.mealsT,
      mealsStrInstructions: mealsStrInstructions ?? this.mealsStrInstructions,
      meals: meals ?? this.meals,
      mealsSearch: mealsSearch ?? this.mealsSearch,
      favourite: favourite ?? this.favourite,
      mealsChoose: mealsChoose ?? this.mealsChoose,

    );
  }

  @override
  List<Object?> get props => [status, mealsPrices,mealsStrInstructions, message, meals, mealsSearch, mealsChoose, mealsSelectedIngredient, mealsStrIngredient, mealsT, favourite];
}
