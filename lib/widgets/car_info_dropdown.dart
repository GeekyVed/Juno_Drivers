import 'package:flutter/material.dart';

class CarTypeDropdownFormField extends StatefulWidget {
  const CarTypeDropdownFormField({
    Key? key,
    required this.label,
    required this.carTypes,
    required this.onSaved,
  }) : super(key: key);

  final String label;
  final List<String> carTypes;
  final Function(String?) onSaved;

  @override
  State<CarTypeDropdownFormField> createState() => _CarTypeDropdownFormFieldState();
}

class _CarTypeDropdownFormFieldState extends State<CarTypeDropdownFormField> {
  String? _selectedCarType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedCarType,
        style: Theme.of(context).textTheme.labelMedium,
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onInverseSurface,
          labelStyle: Theme.of(context).textTheme.labelMedium,
          prefixIcon: const Icon(Icons.directions_car),
          prefixIconColor: Theme.of(context).colorScheme.onSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        dropdownColor: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(18),
        items: widget.carTypes.map((String carType) {
          return DropdownMenuItem<String>(
            value: carType,
            child: Text(
              carType,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCarType = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.label} can\'t be empty!';
          }
          return null;
        },
        onSaved: widget.onSaved,
      ),
    );
  }
}