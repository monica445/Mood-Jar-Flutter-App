import 'package:flutter/material.dart';

import 'button.dart';

class FactorCategoryList extends StatelessWidget {
  final String title;
  final List<String> factors;
  final List<String> selectedFactors;
  final Function(String factor) onFactorToggle;
  const FactorCategoryList({
    super.key, 
    required this.title, 
    required this.factors,
    required this.selectedFactors,
    required this.onFactorToggle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: factors.map((factor) {
            return Button(
              onPressed: () => onFactorToggle(factor),
              textColor: selectedFactors.contains(factor) ? Colors.white : Colors.grey,
              backgroundColor: selectedFactors.contains(factor) ? Color(0xFFfad089) : Colors.grey[200],
              text: factor,
            );
          }).toList(),
        )
      ],
    );
  }
}