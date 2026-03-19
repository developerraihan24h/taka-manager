import 'package:flutter/cupertino.dart';
import 'package:takamanager/core/dbhelper.dart';

import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  // 🔹 Fetch All
  Future LoadCategory() async {
    final db = await DBHelper.getInstance.getDB();
    final result = await db.query('categories');

    _categories = result.map((e) => Category.fromMap(e)).toList();
    notifyListeners();
  }



  // 🔹 Fetch By Type (income / expense)
  List<Category> getByType(String type) {
    return _categories.where((c) => c.type == type).toList();
  }



  // 🔹 Add Category
  Future addCategory(
      String name, String description, String type) async {

    final db = await DBHelper.getInstance.getDB();

    await db.insert('categories', {
      'category_name': name,
      'short_description': description,
      'type': type,
    });

    await LoadCategory();
  }

  //=================
  Future<void> deleteCategory(int id) async {
    final db = await DBHelper.getInstance.getDB();

    await db.delete(
      "categories",
      where: "id=?",
      whereArgs: [id],
    );

    LoadCategory();
    notifyListeners();
  }



}
