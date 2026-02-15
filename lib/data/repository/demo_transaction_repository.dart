import 'dart:developer';

import 'package:expense_tracker/core/data_state/app_error.dart';
import 'package:expense_tracker/core/data_state/data_state.dart';
import 'package:expense_tracker/data/data_src/data_source.dart';
import 'package:expense_tracker/data/model/transaction_model.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:expense_tracker/domain/repository/transaction_repository.dart';

class DemoTransactionRepository implements TransactionRepository {
  final DataSource dataSource;

  const DemoTransactionRepository(this.dataSource);

  @override
  Future<DataState<Transaction>> create(Transaction transaction) async {
    try {
      final data = TransactionModel.fromEntity(transaction);

      final result = await dataSource.createTransaction(data.toJson());

      return SuccessState(data: TransactionModel.fromJson(result).toEntity());
    } on Exception catch (e) {
      log(e.toString());
      //create handles for different exeptions and status code
      return ErrorState(error: AppError("Unknown", "something went wrong"));
    }
  }

  @override
  Future<DataState<void>> delete(int id) async {
    return SuccessState(data: await dataSource.deleteTransaction(id));
  }

  @override
  Future<DataState<List<Transaction>>> getAll() async {
    final result = await dataSource.getTransaction();

    return SuccessState(
      data: result
          .map((element) => TransactionModel.fromJson(element).toEntity())
          .toList(),
    );
  }

  @override
  Future<DataState<List<String>>> getCategories() async {
    try {
      return SuccessState(data: await dataSource.getCategories());
    } on Exception catch (e) {
      log(e.toString());
      return ErrorState(error: AppError("Unknown", "something went wrong"));
    }
  }
}
