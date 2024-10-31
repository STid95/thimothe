import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thimothe/views/glassmorphism.dart';

class AnswerButton extends StatelessWidget {
  final String answer;
  final Function(String) validateAnswer;

  const AnswerButton({super.key, required this.answer, required this.validateAnswer});
  @override
  Widget build(BuildContext context) {
    return GlassMorphism(
      blur: 80.0,
      opacity: 0.6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () => validateAnswer(answer),
        child: Align(alignment: Alignment.center, child: Text(answer, style: Theme.of(context).textTheme.titleLarge)),
      ),
    );
  }
}
