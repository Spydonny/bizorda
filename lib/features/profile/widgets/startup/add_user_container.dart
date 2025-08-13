import 'package:bizorda/features/profile/widgets/shared/profile_text_field.dart';
import 'package:bizorda/features/profile/widgets/shared/submit_button.dart';
import 'package:flutter/material.dart';

class AddUserContainer extends StatelessWidget {
  const AddUserContainer({
    super.key,
    required this.fullnameCtrl,
    required this.nationalIDCtrl,
    required this.positionCtrl,
    required this.passwordCtrl,
    required this.experienceCtrl,
    required this.motivationCtrl,
    this.onSave,
  });

  final TextEditingController fullnameCtrl;
  final TextEditingController nationalIDCtrl;
  final TextEditingController positionCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController experienceCtrl;
  final TextEditingController motivationCtrl;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: Colors.grey[900],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.account_box, color: Colors.white),
                    const Text('Добавить в команду', style: TextStyle(color: Colors.white, fontSize: 16)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ProfileTextField(controller: fullnameCtrl, hintText: 'ФИО', maxLines: 1,),
                ProfileTextField(controller: nationalIDCtrl, hintText: 'ИИН', maxLines: 1,),
                ProfileTextField(controller: positionCtrl, hintText: 'Должность', maxLines: 1,),
                ProfileTextField(controller: passwordCtrl, hintText: 'Пароль', obscureText: true, maxLines: 1,),
                ProfileTextField(controller: experienceCtrl, hintText: 'Опыт'),
                ProfileTextField(controller: motivationCtrl, hintText: 'Мотивация'),
                SubmitButton(onPressed: onSave,)
              ],
            ),
          ),
        ),
      )
    );
  }
}
