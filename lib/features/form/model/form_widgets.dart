import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        keyboardType: keyboardType,
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

  MandatoryDropdownFormField({
    Key? key,
    required this.label,
    required this.value,
    required this.optionsBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> items = optionsBuilder(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        value: items.contains(value) ? value : null,
        onChanged: (newValue) {
          value = newValue!;
        },
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "$label (${AppLocalizations.of(context)!.other})",
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: Theme.of(context).textTheme.subtitle1),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.options.map((option) => ChoiceChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
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
