import 'package:flutter/material.dart';

import '../../../../../widgets/text_fields/transparent_text_field.dart';

class StartupAboutTab extends StatelessWidget {
  const StartupAboutTab({super.key, this.isEditing, this.controller, this.text, });
  final ValueNotifier<bool>? isEditing;
  final TextEditingController? controller;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(18),
          child: controller == null ? Text(
            text ?? '',
            style: TextStyle(color: Colors.white70, height: 1.5),
          )
              :  ValueListenableBuilder<bool>(
            valueListenable: isEditing!,
            builder: (context, editing, ___) {
              if(editing){
                return TransparentTextField(
                  controller: controller,
                  minLines: 2,
                  maxLines: 10,
                  textInputAction: TextInputAction.newline,
                );
              }
              return Text(
                controller!.text,
                style: TextStyle(color: Colors.white70, height: 1.5),
              );
            },

          )
        )
    );
  }
}
