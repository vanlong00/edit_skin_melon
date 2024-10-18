import 'package:edit_skin_melon/core/enum.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

part 'error_text.dart';
part 'validator.dart';

class AppTextFieldWidget extends StatefulWidget {
  const AppTextFieldWidget.string({
    super.key,
    this.title,
    this.type = AppInputType.string,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.label,
  });

  final AppInputType type;
  final String? title;
  final String? initialValue;
  final String? label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<AppTextFieldWidget> createState() => AppTextFieldWidgetState();
}

class AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final ValueNotifier<String?> _errorText = ValueNotifier(null);

  String get value => _controller.text;

  @override
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return AnimatedBuilder(
      animation: _errorText,
      builder: (_, __) {
        return Column(
          children: [
            Row(children: [_buildLabel(), const Gap(8), _buildTextField()]),
            _buildErrorText(),
          ],
        );
      },
    );
  }

  Expanded _buildTextField() {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        onTapOutside: (event) => _focusNode.unfocus(),
        validator: (value) {
          String? error;

          if (isValidator) {
            error = widget.validator?.call(value);
          } else {
            error = _getValidatorDefault.call(value);
          }

          onCheckValidate(error);
          return error != null ? "" : null;
        },
        decoration: InputDecoration(
          errorText: _errorText.value != null ? "" : null,
          errorMaxLines: 1,
          errorStyle: const TextStyle(fontSize: 0),
          label: Text(widget.label ?? ""),
        ),
      ),
    );
  }

  bool get isValidator => widget.validator != null;

  Align _buildErrorText() {
    return Align(
      alignment: Alignment.centerRight,
      child: _ErrorText(
        animatedString: _errorText,
      ),
    );
  }

  Widget _buildLabel() => widget.title != null ? Text(widget.title!) : const SizedBox();

  onCheckValidate(String? error) {
    if (_errorText.value != error) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _errorText.value = error;
      });
    }
  }

  String? _getValidatorDefault(string) {
    switch (widget.type) {
      case AppInputType.string:
        return isString(string);
      default:
        return null;
    }
  }
}
