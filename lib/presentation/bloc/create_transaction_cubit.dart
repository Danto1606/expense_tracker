import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/data_state/app_error.dart';
import 'package:expense_tracker/core/data_state/data_state.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:expense_tracker/domain/repository/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_transaction_state.dart';

class CreateTransactionCubit extends Cubit<CreateTransactionState> {
  CreateTransactionCubit(this.repository)
    : super(
        CreateTransactionState(
          amount: 0,
          merchant: '',
          category: '',
          date: DateTime.now(),
        ),
      );

  final TransactionRepository repository;

  Future<void> save() async {
    if (state.loading) return;
    emit(state.copyWith(loading: true));

    final transaction = Transaction(
      id: -1,
      amount: state.amount,
      merchant: state.merchant,
      category: state.category,
      date: state.date,
      status: 'pending',
    );

    final data = await repository.create(transaction);

    switch (data) {
      case SuccessState _:
        emit(CreateTransactionSuccess());
      case ErrorState(:final error):
        emit(
          CreateTransactionFailed(
            amount: state.amount,
            merchant: state.merchant,
            category: state.category,
            date: state.date,
            error: error,
          ),
        );
    }
  }

  void setAmount(String amount) {
    emit(state.copyWith(amount: double.tryParse(amount) ?? 0));
  }

  void setMerchant(String value) {
    emit(state.copyWith(merchant: value));
  }

  void setCategory(String value) {
    emit(state.copyWith(category: value));
  }

  void setDate(DateTime value) {
    emit(state.copyWith(date: value));
  }
}
