import 'package:app_test/models/hive_meal.dart';
import 'package:app_test/repository/meal_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../models/api_model.dart';

part 'api_event.dart';

part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiStates> {
  final MealRepository mealRepository = MealRepository();
  ApiBloc() : super(const ApiStates()) {
    loadFavourite();
    on<FetchApi>(_fetch);
    on<FetchApiTextD>(_fetchD);
    on<Search>(_search);
    on<ChooseCategory>(_chooseCategory);
    on<Ingredient>(_ingredient);
    on<AddFavourite>(_addFavourite);
    on<RemoveFavourite>(_removeFavourite);
    on<ChooseIngredientsOrAreaOrCategory>(_chooseIngredientsOrAreaOrCategory);
  }
  Future<void> _fetch(FetchApi event, Emitter<ApiStates> emit) async {
      try{
        final allMeals = await mealRepository.fetch();
      emit(state.copyWith(status: StatusFetch.success, meals: allMeals));
    } catch (e) {
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
  Future<void> _fetchD(FetchApiTextD event, Emitter<ApiStates> emit) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php?f=d',
      );
      final apiModel = ApiModel.fromJson(response.data);
      emit(state.copyWith(
        status: StatusFetch.success,
        mealsT: List.from(apiModel.meals ?? []),
      ));
    } catch (e) {
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
  Future<void> _search(Search event, Emitter<ApiStates> emit) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=${event.query}',
      );
      final apiModel = ApiModel.fromJson(response.data);
      emit(
        state.copyWith(
          status: StatusFetch.success,
          mealsSearch: apiModel.meals ?? [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
  Future<void> _chooseCategory(ChooseCategory event, Emitter<ApiStates> emit,) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${event
            .category}',
      );
      final apiModel = ApiModel.fromJson(response.data);
      final mealsWithCategory = (apiModel.meals ?? []).map((meal) {
        meal.strCategory = event.category;
        return meal;
      }).toList();
      emit(
        state.copyWith(
          status: StatusFetch.success,
          mealsChoose: mealsWithCategory,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
  Future<void> _ingredient(Ingredient event, Emitter<ApiStates> emit) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=${event
            .category}',
      );
      final apiModel = ApiModel.fromJson(response.data);
      emit(
        state.copyWith(
          status: StatusFetch.success,
          mealsSelectedIngredient: apiModel.meals ?? [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
  Future<void> _addFavourite(AddFavourite event, Emitter<ApiStates> emit) async {
    final box = await Hive.openBox<MealHive>('favourite');
    final exists = box.values.any((m) => m.idMeal == event.meal.idMeal);
    if (!exists) {
      final mealHive = MealHive(
        idMeal: event.meal.idMeal ?? '',
        strMeal: event.meal.strMeal ?? '',
        strMealThumb: event.meal.strMealThumb ?? '',
      );
      await box.add(mealHive);
    }

    emit(state.copyWith(favourite: box.values.toList()));
  }
  Future<void> _removeFavourite(RemoveFavourite event, Emitter<ApiStates> emit) async {
    final box = await Hive.openBox<MealHive>('favourite');
    final items = box.values
        .where((m) => m.strMeal == event.meal.strMeal)
        .toList();
    if (items.isNotEmpty) {
      await items.first.delete();
    }
    emit(state.copyWith(favourite: box.values.toList()));
  }
  void loadFavourite() async {
    final box = await Hive.openBox<MealHive>('favourite');
    final favourites = box.values.toList();
    emit(state.copyWith(favourite: favourites));
  }
  Future<void> _chooseIngredientsOrAreaOrCategory(ChooseIngredientsOrAreaOrCategory event, Emitter<ApiStates> emit) async {
    final Dio dio = Dio();
    try{
      final String? category = event.category;
      final String? ingredients = event.ingredients;
      final String? area = event.area;
      List<Meals> allMeals = [];
      if(category != null){
        final response = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=${event.category}',
        );
        if(response.data['meals'] != null) {
          allMeals.addAll((response.data["meals"] as List).map((e) => Meals.fromJson(e)).toList());
        }
      }
      if(ingredients != null){
        final response = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/filter.php?i=${event.ingredients}',
        );
        if(response.data['meals'] != null){
          allMeals.addAll((response.data["meals"] as List).map((e) => Meals.fromJson(e)).toList());
        }
      }
      if(area != null){
        final response = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/filter.php?a=${event.area}',
        );
        if(response.data["meals"] != null){
          allMeals.addAll((response.data['meals'] as List).map((e) => Meals.fromJson(e),).toList());
        }
      }
      allMeals = allMeals.toSet().toList();
      emit(state.copyWith(status: StatusFetch.success, mealsSearch: allMeals));
    }catch(e){
      emit(state.copyWith(status: StatusFetch.error, message: e.toString()));
    }
  }
}