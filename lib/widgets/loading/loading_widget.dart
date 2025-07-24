import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.title});
  final String title;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(),
    )
    );
  }
}
