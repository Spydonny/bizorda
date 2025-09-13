import 'dart:io';

import 'package:bizorda/features/feed/data/repos/post_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/shared/profile_text_field.dart';
import '../widgets/shared/submit_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, required this.token});
  final String token;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final PostRepository postRepository;

  final TextEditingController contentController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);


    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void createPost(BuildContext context) async {
    final content = contentController.text;
    try {
      await postRepository.createPost(content, imageFile: selectedImage);
    } catch(e) {
      rethrow;
    }
    if (!context.mounted) return;
    context.go('/profile');
  }

  @override
  void initState() {
    postRepository = PostRepository(token: widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.person, color: Colors.white54),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 22),
                      children: const [
                        TextSpan(
                          text: 'Создать ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: 'пост',
                          style: TextStyle(
                              color: Colors.white38, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Поле описания
              ProfileTextField(controller: contentController, hintText: 'Описание поста...'),
              const SizedBox(height: 12),

              // Предпросмотр изображения
              if (selectedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    selectedImage!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Кнопки
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: OutlinedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.image, color: Colors.white70),
                          label: const Text(
                            'Загрузить фото',
                            style: TextStyle(color: Colors.white70),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero, // убираем лишний padding
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 45,
                      child: SubmitButton(
                        onPressed: () => createPost(context),
                      ),
                    ),
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}

