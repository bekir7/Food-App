import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes App'),
      ),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchRecipes,
              child: Text('Search Ingredient'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _recipes.isEmpty
                  ? Center(
                      child: Text(
                          'There are no recipes yet. Add ingredients and click on the button to bring up the recipes.'))
                  : ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_recipes[index]['title']),
                          onTap: () => _showRecipeDetails(
                              _recipes[index]['id'].toString()),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailsScreen({Key? key, required this.recipeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData['title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipeData['image'] != null)
              Image.network(
                recipeData['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var ingredient in recipeData['extendedIngredients'])
                  Text(
                    ingredient['name'],
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Recipe:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              recipeData['instructions'] ?? 'Recipe details not found.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
