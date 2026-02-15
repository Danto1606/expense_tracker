part of "transaction_bloc.dart";

sealed class TransactionState extends Equatable {
  const TransactionState({
    this.list = const [],
    this.query = '',
    this.selectedCategory = '',
    this.categories = const [],
  });

  final List<Transaction> list;

  final String query;

  final String selectedCategory;

  final List<String> categories;

  double get totalExpense =>
      list.fold(0.0, (total, transaction) => total + transaction.amount);

  //Query to be handle by back-end
  List<Transaction> get transaction {
    if (query.isEmpty && selectedCategory.isEmpty) return list;

    return (query.isEmpty
            ? list.where(
                (transaction) => transaction.category == selectedCategory,
              )
            : list.where(
                (transaction) =>
                    transaction.category == selectedCategory &&
                    transaction.merchant.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              ))
        .toList();
  }

  @override
  List<Object?> get props => [list, query, selectedCategory, categories];
}

final class TransactionFailed extends TransactionState {
  const TransactionFailed({
    required super.list,
    required super.query,
    required super.selectedCategory,
    required super.categories,
    required this.error,
  });
  final AppError error;

  factory TransactionFailed.fromTransactionState(
    TransactionState state,
    AppError error,
  ) {
    return TransactionFailed(
      list: state.list,
      query: state.query,
      selectedCategory: state.selectedCategory,
      categories: state.categories,
      error: error,
    );
  }

  @override
  List<Object?> get props => [list, query, selectedCategory, categories, error];
}

final class TransactionSuccess extends TransactionState {
  const TransactionSuccess({
    required super.list,
    required super.query,
    required super.selectedCategory,
    required super.categories,
  });
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading({
    super.list,
    super.query,
    super.selectedCategory,
    super.categories,
  });

  factory TransactionLoading.fromTransactionState(TransactionState state) {
    return TransactionLoading(
      list: state.list,
      query: state.query,
      selectedCategory: state.selectedCategory,
      categories: state.categories,
    );
  }
}
