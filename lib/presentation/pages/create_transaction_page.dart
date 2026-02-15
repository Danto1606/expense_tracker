import 'package:expense_tracker/presentation/bloc/create_transaction_cubit.dart';
import 'package:expense_tracker/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/presentation/widgets/adaptive_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Add Transaction'),
            titleTextStyle: TextTheme.of(context).titleMedium,
          ),
          body: SingleChildScrollView(
            padding: .symmetric(vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Form(
                  key: _key,
                  child: Column(
                    spacing: 16,
                    children: [
                      _buildResponsiveRow(
                        constraints.maxWidth,
                        children: [
                          AdaptiveTextFormField(
                            labelText: 'Amount',
                            hintText: '0.00',
                            inputType: TextInputType.number,
                            onChanged: context
                                .read<CreateTransactionCubit>()
                                .setAmount,
                            validator: (value) {
                              if (value == null) {
                                return "invalid ammount";
                              }

                              final amount = double.tryParse(value);

                              if (amount == null || amount == 0) {
                                return "invalid ammount";
                              }

                              return null;
                            },
                          ),
                          AdaptiveTextFormField(
                            labelText: 'Merchant',
                            hintText: 'Enter merchant name',
                            onChanged: context
                                .read<CreateTransactionCubit>()
                                .setMerchant,
                            validator: (value) =>
                                value == null || value.length < 3
                                ? "merchant should be atleast 3 characters"
                                : null,
                          ),
                        ],
                      ),
                      _buildResponsiveRow(
                        constraints.maxWidth,
                        children: [
                          AdaptiveDropdownMenu(
                            entries: state.categories,
                            label: 'Category',
                            hint: 'Select category',
                            validator: (value) =>
                                value == null ? "no category selected" : null,
                            onSelect: context
                                .read<CreateTransactionCubit>()
                                .setCategory,
                            width: constraints.maxWidth < 600
                                ? constraints.maxWidth
                                : (constraints.maxWidth / 2) - 24,
                            menuHeight: constraints.maxHeight > 600
                                ? null
                                : 200,
                          ),
                          BlocConsumer<
                            CreateTransactionCubit,
                            CreateTransactionState
                          >(
                            listener: (context, state) {
                              if (state is CreateTransactionSuccess) {
                                context.read<TransactionBloc>().add(
                                  ReloadTransaction(),
                                );
                                _key.currentState?.reset();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Expense tracked")),
                                );
                              }
                              if (state is CreateTransactionFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error.message)),
                                );
                              }
                            },
                            builder: (context, createState) {
                              return AdaptiveDatePickerField(
                                label: 'Date',
                                hint: 'Select Date',
                                selectedDate: createState.date,
                                onDateChanged: context
                                    .read<CreateTransactionCubit>()
                                    .setDate,
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            BlocBuilder<
                              CreateTransactionCubit,
                              CreateTransactionState
                            >(
                              builder: (context, state) {
                                return FilledButton(
                                  onPressed: state.loading
                                      ? null
                                      : () {
                                          if (_key.currentState?.validate() ==
                                              true) {
                                            _key.currentState?.save();
                                            context
                                                .read<CreateTransactionCubit>()
                                                .save();
                                          }
                                        },
                                  style: FilledButton.styleFrom(
                                    fixedSize: Size(600, 56),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Text('Add Transaction'),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Widget _buildResponsiveRow(double width, {required List<Widget> children}) {
  if (width < 600) {
    return Column(spacing: 16, children: children);
  }

  return Row(
    children: children.map((element) => Expanded(child: element)).toList(),
  );
}
