part of 'transaction_bloc.dart';

sealed class TransactionEvent {
  const TransactionEvent();
}

class LoadTransaction extends TransactionEvent {
  const LoadTransaction();
}

class DeleteTransaction extends TransactionEvent {
  const DeleteTransaction(this.id);

  final int id;
}

class SearchTransaction extends TransactionEvent {
  const SearchTransaction(this.query);

  final String query;
}

class SelectTransactionCategory extends TransactionEvent {
  const SelectTransactionCategory([this.category = '']);

  final String category;
}

class ReloadTransaction extends TransactionEvent {
  const ReloadTransaction();
}
