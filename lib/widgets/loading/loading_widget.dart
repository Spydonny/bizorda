import 'package:bizorda/widgets/navigation_widgets/navigation_button.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.title});
  final String title;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavigationButton(chosenIdx: 0, isLoading: true),
            Text(title),
            SizedBox(width: 25,)
          ],
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
