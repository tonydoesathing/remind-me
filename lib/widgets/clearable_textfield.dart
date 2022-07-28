import 'package:flutter/material.dart';

// class ClearableTextField extends TextField {
//   final String? initialValue;
//   final Function(String?)? onChanged;
//   final TextField field;

//   ClearableTextField({Key? key, this.initialValue, this.onChanged, this.field})
//       : super(key: key);
// }

class ClearableTextField extends StatefulWidget {
  final String? initialValue;
  final Function(String?)? onChanged;
  final String? errorText;
  final String? label;
  final Widget? prefix;
  const ClearableTextField(
      {Key? key,
      this.initialValue,
      this.onChanged,
      this.errorText,
      this.label,
      this.prefix})
      : super(key: key);

  @override
  State<ClearableTextField> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<ClearableTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: _controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          prefixIcon: widget.prefix,
          errorText: widget.errorText,
          suffix: InkWell(
            onTap: () {
              _controller.text = "";
              widget.onChanged?.call("");
            },
            customBorder: const CircleBorder(),
            child: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )),
    );
  }
}


/*
TextFormField(
                  initialValue: state.url,
                  onChanged: (value) {
                    context.read<EditBloc>().add(UpdateLocalReminderEvent(
                        state.title,
                        value,
                        state.schedule,
                        state.initialReminder));
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "URL",
                      prefixIcon: const Icon(Icons.public),
                      errorText: state is EditSaveFailure
                          ? state.error.payloadError
                          : null,
                      suffix: InkWell(
                        onTap: () {},
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )),
                ),

*/