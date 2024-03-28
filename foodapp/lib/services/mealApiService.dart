import 'dart:convert';
import 'package:http/http.dart' as http;

class MealApiService {
  final String apiKey;
  final String baseUrl =
      'https://api.spoonacular.com/recipes/findByIngredients';

  MealApiService(this.apiKey);

  Future<List<Map<String, dynamic>>> getRecipesByIngredients(
      List<String> ingredients) async {
    final response = await http.get(
      Uri.parse('$baseUrl?apiKey=$apiKey&ingredients=${ingredients.join(',')}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
