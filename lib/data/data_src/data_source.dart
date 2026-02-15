abstract class DataSource {
  Future<List<String>> getCategories();
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getTransaction();
  Future<void> deleteTransaction(int id);
}
