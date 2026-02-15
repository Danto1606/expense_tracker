import 'package:expense_tracker/core/data_state/data_state.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';

abstract class TransactionRepository {
  Future<DataState<List<Transaction>>> getAll();
  Future<DataState<Transaction>> create(Transaction transaction);
  Future<DataState<void>> delete(int id);
  Future<DataState<List<String>>> getCategories();
}
