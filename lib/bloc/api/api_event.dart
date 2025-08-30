part of 'api_bloc.dart';

@immutable
sealed class ApiEvent extends Equatable{}
final class FetchApi extends ApiEvent{
  @override
  List<Object?> get props => [];
}
final class FetchApiTextD extends ApiEvent{
  @override
  List<Object?> get props => [];
}
class Search extends ApiEvent{
  final String query;
  final String? category;
  final String? ingredients;
  final String? area;
  Search(this.query, {this.category, this.ingredients, this.area});
  @override
  List<Object?> get props => [query, category, ingredients, area];
}
class ChooseCategory extends ApiEvent{
  final String category;
  ChooseCategory({required this.category});
  @override
  List<Object?> get props => [ category];
}
class Ingredient extends ApiEvent{
  final String category;
  Ingredient({required this.category});
  @override
  List<Object?> get props => [ category];
}
class AddFavourite extends ApiEvent{
  final Meals meal;
  AddFavourite({required this.meal});
  @override
  // TODO: implement props
  List<Object?> get props => [meal];
}
class RemoveFavourite extends ApiEvent{
  final Meals meal;
  RemoveFavourite({required this.meal});
  @override
  // TODO: implement props
  List<Object?> get props => [meal];
}
class ChooseIngredientsOrAreaOrCategory extends ApiEvent{
  final String? category;
  final String? ingredients;
  final String? area;
  ChooseIngredientsOrAreaOrCategory({required this.category,required this.ingredients,required this.area});
  @override
  // TODO: implement props
  List<Object?> get props => [ category,ingredients,area];
}

