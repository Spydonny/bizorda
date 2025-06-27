import 'package:flutter/material.dart';

import '../../../theme.dart';

class LabelLocal extends StatelessWidget {
  const LabelLocal(this.text ,{super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: AppColors.labelColor, fontWeight: FontWeight.w200),
    );
  }
}
