import 'package:expense_tracker/core/router/pages.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/presentation/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdaptiveTransactionPage extends StatelessWidget {
  const AdaptiveTransactionPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final page = GoRouterState.of(context).topRoute?.name;
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
          body: BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionFailed) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error.message)));
              }
            },
            listenWhen: (previous, current) => current is TransactionFailed,
            child: LayoutBuilder(
              builder: (context, constraint) {
                if (constraint.maxWidth < 600 || page == Pages.newTransaction) {
                  return SizedBox(
                    key: const ValueKey("mobile_view"),
                    child: child,
                  );
                }

                return Row(
                  key: const ValueKey("tablet_view"),
                  children: [
                    SizedBox(
                      height: double.maxFinite,
                      width: constraint.maxWidth / 2.2,
                      child: TransactionListPage(),
                    ),
                    Expanded(
                      child: page == Pages.transactionDetail
                          ? child
                          : const Center(
                              child: Text("Select an item to view details"),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: page == Pages.transactionList
              ? FloatingActionButton(
                  onPressed: () => context.pushNamed(Pages.newTransaction),
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
