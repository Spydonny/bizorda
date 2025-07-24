import 'package:bizorda/features/profile/widgets/startup/button_local.dart';
import 'package:flutter/material.dart';

class StartupHeader extends StatefulWidget {
  const StartupHeader({super.key, required this.name, required this.sphere, this.onConnect});
  final String name;
  final String sphere;
  final VoidCallback? onConnect;

  @override
  State<StartupHeader> createState() => _StartupHeaderState();
}

class _StartupHeaderState extends State<StartupHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .appBarTheme
          .backgroundColor,
      padding: const EdgeInsets.only(left: 56, right: 18, bottom: 16),
      child: Row(
          children: [
            const CircleAvatar(radius: 48, backgroundColor: Colors.white24),
            SizedBox(width: 15,),
            Column(
              children: [
                Text(widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.sphere,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            // widget.onConnect == null ? SizedBox()
            //     : ButtonLocal(
            //   label: 'Связаться',
            //   iconData: Icons.chat_bubble_outline_outlined,
            //   onPressed: widget.onConnect,
            // ),
          ]
      ),
    );
  }
}
