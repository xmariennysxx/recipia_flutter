import 'dart:convert';
import 'package:recipia/pages/favourite_page.dart';
import 'package:recipia/pages/home_page.dart';
import 'package:recipia/pages/search_page.dart';
import 'package:recipia/util/bottom_nav_bar.dart';
import 'package:recipia/util/global.dart';
import 'package:recipia/util/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Map<String, dynamic>> recipes;
  @override
  void initState() {
    recipes = getRecipes();
    super.initState();
  }

  Future<Map<String, dynamic>> getRecipes() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.spoonacular.com/recipes/random?apiKey=$spoonacularApi&includeNutrition=false&number=10'),
      );
      final data = jsonDecode(res.body);
      if (data['totalResults'] == 0) {
        throw 'Sin Resultados';
      }
      return data;
    } catch (e) {
      throw 'Error de conexión';
    }
  }

  int _selectIndex = 0;

  void navigateBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const FavouritePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBar(index),
      ),
      body: FutureBuilder(
          future: recipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            data = snapshot.data!;
            return Container(
              child: _pages[_selectIndex],
            );
          }),
    );
  }
}