import 'package:expense_tracker/core/router/pages.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/presentation/widgets/adaptive_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TransactionListHeader(),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: state.transaction.length,
                  separatorBuilder: (_, _) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final item = state.transaction[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      title: Text(item.merchant),
                      subtitle: Text(item.category),
                      trailing: Column(
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'en_NG',
                              symbol: '₦',
                            ).format(item.amount),
                            style: TextTheme.of(context).labelLarge?.copyWith(
                              color: ColorScheme.of(context).error,
                            ),
                          ),
                          Text(DateFormat('dd/MM/yyyy').format(item.date)),
                        ],
                      ),

                      // routing to details page
                      onTap: () {
                        final name = GoRouterState.of(context).topRoute?.name;
                        if (name == Pages.transactionDetail) {
                          context.pushReplacementNamed(
                            Pages.transactionDetail,
                            extra: item,
                          );
                        } else {
                          context.pushNamed(
                            Pages.transactionDetail,
                            extra: item,
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionListHeader extends StatelessWidget {
  const TransactionListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: ColorScheme.of(context).primary,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        "Expense Tracker",
                        style: TextTheme.of(context).titleSmall?.copyWith(
                          color: ColorScheme.of(context).onPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications),
                        color: ColorScheme.of(context).onPrimary,
                      ),
                    ],
                  ),
                ),

                Center(
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (_, state) => Text(
                      NumberFormat.currency(
                        locale: 'en_NG',
                        symbol: '₦',
                      ).format(state.totalExpense),
                      style: TextTheme.of(context).titleMedium?.copyWith(
                        color: ColorScheme.of(context).onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Material(
                  color: ColorScheme.of(context).primaryFixedDim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AdaptiveTextFormField(
                      onChanged: (text) => context.read<TransactionBloc>().add(
                        SearchTransaction(text),
                      ),
                      filled: true,
                      leading: Icon(Icons.search),
                      hintText: "Search merchants",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (_, state) {
            return SizedBox(
              height: 56,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ChoiceChip(
                      selected: state.selectedCategory.isEmpty,
                      label: Text("All"),
                      selectedColor: ColorScheme.of(context).primary,
                      onSelected: (_) => context.read<TransactionBloc>().add(
                        SelectTransactionCategory(),
                      ),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: state.selectedCategory.isEmpty
                            ? ColorScheme.of(context).onPrimary
                            : null,
                      ),
                    );
                  }

                  final item = state.categories[index - 1];

                  return ChoiceChip(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    selected: item == state.selectedCategory,
                    label: Text(item),
                    selectedColor: ColorScheme.of(context).primary,
                    onSelected: (_) => context.read<TransactionBloc>().add(
                      SelectTransactionCategory(item),
                    ),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: item == state.selectedCategory
                          ? ColorScheme.of(context).onPrimary
                          : null,
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 8),
              ),
            );
          },
        ),
      ],
    );
  }
}
