import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'themes.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle, // theme.dart
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            // BoxDecoration
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // Date: 텍스트 필드에 widget 파라미터가 있는 경우 삼항 연산
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                    Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: controller,
                    style: subTitleStyle,
                    // theme.dart
                    decoration: InputDecoration(
                      hintText: hint,
                      // MyInputField(title: "Title", hint: "Enter your title"),
                      hintStyle: subTitleStyle,
                      // theme.dart
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.backgroundColor, width: 0),
                      ),
                      // UnderlineInputBorder
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.backgroundColor, width: 0),
                      ), // UnderlineInputBorder
                    ), // InputDecoration
                  ), // textFormField
                ), // expanded
                widget == null ? Container() : Container(child: widget),
              ],
            ), //row
          ), // container
        ],
      ), // column
    ); // container
  }
}
