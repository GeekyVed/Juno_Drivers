import 'package:flutter/material.dart';

class CarInfoInput extends StatefulWidget {
  CarInfoInput({
    super.key,
    required this.label,
    required this.onSave,
    this.minLength = 1,
  });

  final String label;
  final int minLength;
  final Function(String) onSave;

  @override
  State<CarInfoInput> createState() => _CarInfoInputState();
}

class _CarInfoInputState extends State<CarInfoInput> {
  final int maxLength = 50;

  Icon getPrefixIcon(String label) {
  switch (label.toLowerCase()) {
    case 'car model':
      return const Icon(
        Icons.directions_car,  // Using a car icon for car model
      );
    case 'car number':
      return const Icon(
        Icons.pin,  // Using a pin icon for car number (like a license plate)
      );
    case 'car color':
      return const Icon(
        Icons.color_lens,  // Using a color palette icon for car color
      );
    default:
      return const Icon(
        Icons.info,
      );
  }
}
  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          label: Text(
            widget.label,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onInverseSurface,
          labelStyle: Theme.of(context).textTheme.labelMedium,
          prefixIcon: getPrefixIcon(widget.label),
          prefixIconColor: Theme.of(context).colorScheme.onSurface,
          suffixIconColor: Theme.of(context).colorScheme.onSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              18,
            ),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '${widget.label} can\'t be empty!';
          }

          if (value.trim().length > maxLength) {
            return '${widget.label} can\'t be more than $maxLength!';
          }

          if (value.trim().length < widget.minLength) {
            return 'Enter a valid ${widget.label}!';
          }

          return null;
        },
        onSaved: (value) {
          widget.onSave(value!.trim());
        },
      ),
    );
  }
}
