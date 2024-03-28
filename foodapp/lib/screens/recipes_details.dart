import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailsScreen({Key? key, required this.recipeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4ebd0),
        appBar: AppBar(
          backgroundColor: Color(0xFFd6ad60),
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
      ),
    );
  }
}
