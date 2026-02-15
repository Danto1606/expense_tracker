import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/router/pages.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:expense_tracker/presentation/bloc/create_transaction_cubit.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/presentation/pages/adaptive_transaction_page.dart';
import 'package:expense_tracker/presentation/pages/create_transaction_page.dart';
import 'package:expense_tracker/presentation/pages/transaction_detail_page.dart';
import 'package:expense_tracker/presentation/pages/transaction_list_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _baseKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: "/list",
  navigatorKey: _baseKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (context, state, child) => BlocProvider(
        create: (_) => sl<TransactionBloc>(),
        child: AdaptiveTransactionPage(child: child),
      ),
      routes: [
        GoRoute(
          path: "/list",
          name: Pages.transactionList,
          builder: (context, _) => TransactionListPage(),
        ),
        GoRoute(
          path: "/detail",
          name: Pages.transactionDetail,
          builder: (context, state) =>
              TransactionDetailPage(item: state.extra as Transaction),
        ),
        GoRoute(
          path: "/create",
          name: Pages.newTransaction,
          builder: (context, _) => BlocProvider(
            create: (_) => sl<CreateTransactionCubit>(),
            child: CreateTransactionPage(),
          ),
        ),
      ],
    ),
  ],
);
