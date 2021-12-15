// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: camel_case_types, must_be_immutable
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';


class Custom_ListTile_TextField extends StatelessWidget {
  TextEditingController? controller;
  FormFieldValidator? validations;
  bool read;
  bool isMask;
  var mask;
  var labelText;
  var hintText;
  int? maxLines;

  Custom_ListTile_TextField(
      {Key? key, required this.isMask,
        this.mask,
        required this.read,
        this.controller,
        this.validations,
        this.labelText,
        this.hintText,
        this.maxLines
      //  required this.textInput
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        maxLines: maxLines ?? 1,
        inputFormatters:
        isMask ? [TextInputMask(mask: mask, reverse: false)] : null,
        readOnly: read,
       // keyboardType: textInput == null ? TextInputType.text : textInput,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
           // fillColor: ThemeColors.confidenceBlue,
            filled: read ? true : false),
        controller: controller,
        validator: validations,
      ),
    );
  }
}

class Custom_ListTile_TextField_Icon extends StatelessWidget {
  TextEditingController controller;
  String Function(String) validations;
  bool read;
  bool isMask;
  var mask;
  var labelText;
  var hintText;
  TextInputType textInput;
  dynamic onPressed;

  Custom_ListTile_TextField_Icon(
      {required this.isMask,
        this.mask,
        required this.read,
        required this.controller,
        required this.validations,
        this.labelText,
        this.hintText,
        required this.textInput,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 9,
        child: ListTile(
          title: TextFormField(
            inputFormatters: isMask
                ? [TextInputMask(mask: this.mask, reverse: false)]
                : null,
            readOnly: this.read,
            keyboardType: textInput == null ? TextInputType.text : textInput,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                labelText: this.labelText,
                hintText: this.hintText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
             //   fillColor: ThemeColors.confidenceBlue,
                filled: read ? true : false),
            controller: this.controller,
            // validator: this.validations,
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: IconButton(
          icon: Icon(Icons.camera),
          onPressed: this.onPressed,
        ),
      )
    ]);
  }
}
