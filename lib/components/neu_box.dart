import 'package:flutter/material.dart';
import 'package:music_app/themes/theme_changer.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  const NeuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            //dark shadow bottom right
            color: isDarkMode ? Colors.black : Colors.grey.shade300,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),
          //light shadow top left
          BoxShadow(
            color: isDarkMode ? Colors.grey.shade700 : Colors.white,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
