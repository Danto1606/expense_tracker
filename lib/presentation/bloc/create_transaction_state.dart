part of 'create_transaction_cubit.dart';

class CreateTransactionState extends Equatable {
  final double amount;
  final String merchant;
  final String category;
  final DateTime date;
  final bool loading;

  const CreateTransactionState({
    required this.amount,
    required this.merchant,
    required this.category,
    required this.date,
    this.loading = false,
  });

  @override
  List<Object?> get props => [amount, merchant, category, date, loading];

  CreateTransactionState copyWith({
    double? amount,
    String? merchant,
    String? category,
    DateTime? date,
    bool? loading,
  }) {
    return CreateTransactionState(
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      date: date ?? this.date,
      loading: loading ?? this.loading,
    );
  }
}

class CreateTransactionFailed extends CreateTransactionState {
  const CreateTransactionFailed({
    required super.amount,
    required super.merchant,
    required super.category,
    required super.date,
    required this.error,
  }) : super(loading: false);

  final AppError error;

  @override
  List<Object?> get props => [amount, merchant, category, date, loading, error];
}

class CreateTransactionSuccess extends CreateTransactionState {
  CreateTransactionSuccess()
    : super(
        amount: 0,
        merchant: '',
        category: '',
        date: DateTime.now(),
        loading: false,
      );
}
