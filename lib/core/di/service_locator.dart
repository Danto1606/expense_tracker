import 'package:expense_tracker/data/data_src/data_source.dart';
import 'package:expense_tracker/data/data_src/demo_data_src.dart';
import 'package:expense_tracker/data/repository/demo_transaction_repository.dart';
import 'package:expense_tracker/domain/repository/transaction_repository.dart';
import 'package:expense_tracker/presentation/bloc/create_transaction_cubit.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  sl
    ..registerLazySingleton<DataSource>(() => DemoDataSrc())
    ..registerLazySingleton<TransactionRepository>(
      () => DemoTransactionRepository(sl()),
    )
    ..registerFactory(() => TransactionBloc(sl()))
    ..registerFactory(() => CreateTransactionCubit(sl()));
}
