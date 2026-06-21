import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<void> addCategory(CategoryModel category);

  Future<List<CategoryModel>> getCategories();

  Future<void> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class SupabaseCategoryRemoteDataSource implements CategoryRemoteDataSource {
  final SupabaseClient _client;

  const SupabaseCategoryRemoteDataSource(this._client);

  static const String tableName = 'categories';

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _client.from(tableName).upsert(category.toJson());
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.from(tableName).select();
    return (response as List)
        .map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json)))
        .toList(growable: false);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _client.from(tableName).upsert(category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _client.from(tableName).delete().eq('id', id);
  }
}
