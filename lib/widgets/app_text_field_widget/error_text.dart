part of 'app_text_field_widget.dart';

class _ErrorText extends StatefulWidget {
  final ValueNotifier<String?> animatedString;

  const _ErrorText({required this.animatedString});

  @override
  State<_ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<_ErrorText> {
  late ValueNotifier<String?> animatedString = widget.animatedString;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animatedString,
      builder: (_, __) {
        return animatedString.value != null
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            animatedString.value ?? "",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        )
            : const SizedBox();
      },
    );
  }
}