import 'package:expense_tracker/core/util/extensions.dart';
import 'package:expense_tracker/domain/entity/transaction.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key, required this.item});

  final Transaction item;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, _) {
        context.pop();
      },
      listenWhen: (previous, current) =>
          previous is TransactionLoading && current is TransactionSuccess,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transaction Detail'),
          titleTextStyle: TextTheme.of(context).titleMedium,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.read<TransactionBloc>().add(DeleteTransaction(item.id));
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: ColorScheme.of(context).error,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Text(
                NumberFormat.currency(
                  locale: 'en_NG',
                  symbol: '₦',
                ).format(item.amount),
                style: TextTheme.of(context).headlineMedium?.copyWith(
                  color: ColorScheme.of(context).error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                item.merchant,
                style: TextTheme.of(
                  context,
                ).titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              Card(
                color: ColorScheme.of(context).primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4,
                  ),

                  child: Text(
                    item.category,
                    style: TextStyle(color: ColorScheme.of(context).onPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Divider(),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text("Date:", style: TextTheme.of(context).titleMedium),
                  const SizedBox(width: 8),
                  Text(
                    item.date.getOrdinalDate(),
                    style: TextTheme.of(context).titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text("Status:", style: TextTheme.of(context).titleMedium),
                  const SizedBox(width: 8),

                  Card(
                    color: item.status == "completed"
                        ? ColorScheme.of(context).primary
                        : ColorScheme.of(context).error,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4,
                      ),

                      child: Row(
                        mainAxisSize: .min,
                        spacing: 4,
                        children: [
                          Text(
                            item.status,
                            style: TextStyle(
                              color: item.status == "completed"
                                  ? ColorScheme.of(context).onPrimary
                                  : ColorScheme.of(context).onError,
                            ),
                          ),
                          Icon(
                            item.status == "completed"
                                ? Icons.check
                                : Icons.pending_actions_outlined,
                            color: item.status == "completed"
                                ? ColorScheme.of(context).onPrimary
                                : ColorScheme.of(context).onError,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Transaction ID:",
                    style: TextTheme.of(context).titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Text('#${item.id}', style: TextTheme.of(context).titleMedium),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
