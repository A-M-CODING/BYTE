import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/app_theme.dart';
class MandatoryTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const MandatoryTextFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);  // Access custom theme properties

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          labelStyle: theme.bodyText1,  // Apply custom style from AppTheme
        ),
        keyboardType: keyboardType,
        style: theme.bodyText1,  // Apply text style to the input text
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.fieldRequired;
          }
          return null;
        },
      ),
    );
  }
}

class MandatoryDropdownFormField extends StatelessWidget {
  final String label;
  String value;
  final List<String> Function(BuildContext) optionsBuilder;
  final Function(String) onValueChange;  // Callback to update parent state

  MandatoryDropdownFormField({
    Key? key,
    required this.label,
    required this.value,
    required this.optionsBuilder,
    required this.onValueChange,  // Pass this in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    List<String> items = optionsBuilder(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          labelStyle: theme.bodyText1,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        value: items.contains(value) ? value : null,
        onChanged: (newValue) {
          onValueChange(newValue!);  // Use callback to update parent state
        },
        items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: theme.bodyText1)
        )).toList(),
        style: theme.bodyText1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.fieldRequired;
          }
          return null;
        },
      ),
    );
  }
}

class OtherTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const OtherTextFormField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);  // Access custom theme properties

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "$label (${AppLocalizations.of(context)!.other})",
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          labelStyle: theme.bodyText1,  // Apply custom style from AppTheme
          border: OutlineInputBorder(  // Optional to enhance visuals
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: theme.bodyText1,  // Apply text style to the input text
      ),
    );
  }
}

class MultiSelectChipField extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;

  const MultiSelectChipField({
    Key? key,
    required this.label,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MultiSelectChipFieldState createState() => _MultiSelectChipFieldState();
}

class _MultiSelectChipFieldState extends State<MultiSelectChipField> {
  late List<String> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);  // Access custom theme properties

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: theme.subtitle1),  // Apply subtitle style from theme
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.options.map((option) => ChoiceChip(
              label: Text(option, style: theme.bodyText1),  // Apply body text style from theme to each chip
              selected: selectedOptions.contains(option),
              selectedColor: theme.chipColor,  // Assuming 'pinkColor' is defined in your AppTheme
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                  widget.onSelectionChanged(selectedOptions);
                });
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}