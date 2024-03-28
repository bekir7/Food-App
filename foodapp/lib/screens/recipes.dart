import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/recipes_details.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ingredientController = TextEditingController();
  List<String> _ingredients = [];
  List<Map<String, dynamic>> _recipes = [];

  Future<void> _fetchRecipes() async {
    final apiKey =
        '3dddd2b0ef0348bb92c625628ca0de23'; // Spoonacular API anahtarınızı buraya ekleyin
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/findByIngredients?ingredients=${_ingredients.join(', ')}&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _recipes = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  void _addIngredient() {
    final newIngredient = _ingredientController.text.trim();
    if (newIngredient.isNotEmpty) {
      setState(() {
        _ingredients.add(newIngredient);
        _ingredientController.clear();
      });
    }
  }

  void _searchRecipes() {
    if (_ingredients.isNotEmpty) {
      _fetchRecipes();
    }
  }

  Future<void> _showRecipeDetails(String recipeId) async {
    final apiKey =
        '3dddd2b0ef0348bb92c625628ca0de23'; // Spoonacular API anahtarınızı buraya ekleyin
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailsScreen(recipeData: data),
        ),
      );
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4ebd0),
        // appBar: AppBar(
        //   title: Text(
        //     'Recipes App',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   backgroundColor: Color(0xFF50514F),
        // ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Add Ingredient',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _searchRecipes,
                child: Text(
                  'Search Ingredient',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: _recipes.isEmpty
                    ? Center(
                        child: Text(
                            'There are no recipes yet. Add ingredients and click on the button to bring up the recipes.'))
                    : ListView.builder(
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              tileColor: Color(0xFFd6ad60),
                              title: Text(
                                _recipes[index]['title'],
                                style: TextStyle(fontSize: 17),
                              ),
                              onTap: () => _showRecipeDetails(
                                  _recipes[index]['id'].toString()),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
