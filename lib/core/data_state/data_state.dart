import 'package:expense_tracker/core/data_state/app_error.dart';

sealed class DataState<T> {
  const DataState();

  abstract final T? data;
  abstract final AppError? error;
}

final class SuccessState<T> extends DataState<T> {
  const SuccessState({required this.data});

  @override
  final T data;

  @override
  final AppError? error = null;
}

final class ErrorState<T> extends DataState<T> {
  const ErrorState({required this.error});

  @override
  final AppError error;

  @override
  final T? data = null;
}
