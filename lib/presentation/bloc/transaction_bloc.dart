import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/data_state/app_error.dart';
import 'package:expense_tracker/core/data_state/data_state.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:expense_tracker/domain/repository/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this.repository) : super(TransactionLoading()) {
    on<LoadTransaction>(load);
    on<DeleteTransaction>(delete);
    on<SearchTransaction>(search);
    on<SelectTransactionCategory>(selectCategory);
    on<ReloadTransaction>(reload);

    add(LoadTransaction());
  }

  final TransactionRepository repository;

  Future<void> load(
    LoadTransaction event,
    Emitter<TransactionState> emitter,
  ) async {
    final categories = await repository.getCategories();
    if (categories case ErrorState(:var error)) {
      emitter(TransactionFailed.fromTransactionState(state, error));
      return;
    }

    final transactions = await repository.getAll();

    switch (transactions) {
      case SuccessState(:final data):
        emitter(
          TransactionSuccess(
            list: data,
            query: state.query,
            selectedCategory: state.selectedCategory,
            categories: categories.data!,
          ),
        );
      case ErrorState(:final error):
        emitter(TransactionFailed.fromTransactionState(state, error));
    }
  }

  Future<void> reload(
    ReloadTransaction event,
    Emitter<TransactionState> emitter,
  ) async {
    final transactions = await repository.getAll();

    switch (transactions) {
      case SuccessState(:final data):
        emitter(
          TransactionSuccess(
            list: data,
            query: state.query,
            selectedCategory: state.selectedCategory,
            categories: state.categories,
          ),
        );
      case ErrorState(:final error):
        emitter(TransactionFailed.fromTransactionState(state, error));
    }
  }

  Future<void> delete(
    DeleteTransaction event,
    Emitter<TransactionState> emitter,
  ) async {
    emitter(TransactionLoading.fromTransactionState(state));

    final transaction = await repository.delete(event.id);

    switch (transaction) {
      case SuccessState _:
        add(ReloadTransaction());
      case ErrorState(:final error):
        emitter(TransactionFailed.fromTransactionState(state, error));
    }
  }

  void search(SearchTransaction event, Emitter<TransactionState> emitter) {
    emitter(
      TransactionSuccess(
        list: state.list,
        query: event.query,
        selectedCategory: state.selectedCategory,
        categories: state.categories,
      ),
    );
  }

  void selectCategory(
    SelectTransactionCategory event,
    Emitter<TransactionState> emitter,
  ) {
    emitter(
      TransactionSuccess(
        list: state.list,
        query: state.query,
        selectedCategory: event.category,
        categories: state.categories,
      ),
    );
  }
}
