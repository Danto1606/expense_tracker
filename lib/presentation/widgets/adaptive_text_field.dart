import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    required this.decoration,
    this.onChanged,
  });

  final InputDecoration decoration;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoTextField(
        placeholder: decoration.hintText,
        onChanged: onChanged,
        prefix: decoration.prefixIcon,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(color: CupertinoColors.systemGrey4),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    return TextFormField(onChanged: onChanged, decoration: decoration);
  }
}

class AdaptiveTextFormField extends StatelessWidget {
  const AdaptiveTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
  });

  final void Function(String)? onChanged;
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final TextInputAction inputAction;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoFormSection.insetGrouped(
        margin: .symmetric(horizontal: 16),
        backgroundColor: Colors.transparent,
        header: Text(labelText),
        children: [
          CupertinoTextFormFieldRow(
            placeholder: hintText,
            onChanged: onChanged,
            validator: validator,
            keyboardType: inputType,
            textInputAction: inputAction,
            inputFormatters: inputType == TextInputType.number
                ? [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^-?\d*\.?\d{0,2}'),
                    ),
                  ]
                : null,
          ),
        ],
      );
    }
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 4,
        children: [
          Text(labelText, style: InputDecorationTheme.of(context).labelStyle),
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
            textInputAction: inputAction,
            onChanged: onChanged,
            validator: validator,
            keyboardType: inputType,
            inputFormatters: inputType == TextInputType.number
                ? [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^-?\d*\.?\d{0,2}'),
                    ),
                  ]
                : null,
          ),
        ],
      ),
    );
  }
}

class AdaptiveDropdownMenu extends StatefulWidget {
  const AdaptiveDropdownMenu({
    super.key,
    required this.entries,
    required this.label,
    required this.hint,
    this.onSelect,
    this.width = double.maxFinite,
    this.menuHeight,
    this.validator,
  });
  final List<String> entries;
  final String label;
  final String hint;
  final void Function(String)? onSelect;
  final double width;
  final double? menuHeight;
  final String? Function(String?)? validator;

  @override
  State<AdaptiveDropdownMenu> createState() => _AdaptiveDropdownMenuState();
}

class _AdaptiveDropdownMenuState extends State<AdaptiveDropdownMenu> {
  late final TextEditingController _dropdownController;

  @override
  void initState() {
    super.initState();
    _dropdownController = TextEditingController();
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      onReset: () => _dropdownController.clear(),
      initialValue: null,
      errorBuilder: (_, _) => const SizedBox(),
      builder: (formState) {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return CupertinoFormSection.insetGrouped(
            margin: .symmetric(horizontal: 16),
            backgroundColor: Colors.transparent,
            header: Text(widget.label),
            children: [
              CupertinoFormRow(
                error: formState.hasError ? Text(formState.errorText!) : null,
                child: CupertinoTextField.borderless(
                  placeholder: formState.value ?? widget.hint,
                  suffix: Icon(CupertinoIcons.chevron_down),
                  controller: _dropdownController,
                  readOnly: true,
                  onTap: () =>
                      _showCupertinoPicker(context, formState.didChange),
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: .symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Text(
                widget.label,
                style: InputDecorationTheme.of(context).labelStyle,
              ),
              DropdownMenu(
                width: widget.width,
                errorText: formState.errorText,
                controller: _dropdownController,
                hintText: widget.hint,
                menuHeight: widget.menuHeight,
                onSelected: (value) {
                  if (value == null) return;
                  widget.onSelect?.call(value);
                  formState.didChange(value);
                },
                dropdownMenuEntries: [
                  for (final entry in widget.entries)
                    DropdownMenuEntry(value: entry, label: entry),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCupertinoPicker(
    BuildContext context,
    void Function(String?) onChange,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(widget.label),
        message: Text(widget.hint),
        actions: <CupertinoActionSheetAction>[
          for (final entry in widget.entries)
            CupertinoActionSheetAction(
              onPressed: () {
                widget.onSelect?.call(entry);
                onChange(entry);
                context.pop(context);
              },
              child: Text(entry),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => context.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class AdaptiveDatePickerField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final String hint;

  const AdaptiveDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat.yMMMd().format(selectedDate);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoFormSection.insetGrouped(
        margin: .symmetric(horizontal: 16),
        backgroundColor: Colors.transparent,
        header: Text(label),
        children: [
          CupertinoFormRow(
            child: CupertinoTextField.borderless(
              placeholder: hint,
              suffix: Icon(CupertinoIcons.calendar),
              readOnly: true,
              onTap: () => _showCupertinoPicker(context),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const .symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: InputDecorationTheme.of(context).labelStyle),
          const SizedBox(height: 4),
          TextFormField(
            controller: TextEditingController(text: dateString),
            readOnly: true,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: const Icon(Icons.calendar_month_outlined),
              border: const OutlineInputBorder(),
            ),
            onTap: () => _showMaterialPicker(context),
          ),
        ],
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            _buildPickerHeader(context),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                onDateTimeChanged: onDateChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMaterialPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  Widget _buildPickerHeader(BuildContext context) {
    return Container(
      color: CupertinoColors.secondarySystemBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoButton(
            child: const Text('Done'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
