import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Localization/current_language.dart';
import '../Localization/language_constants.dart';
import '../Utils/color_utils.dart';
import '../Utils/main_utils.dart';
import 'custom_decorated_input_border.dart';

class CustomTextField extends StatelessWidget {
  final dynamic validator;
  final dynamic suffixIcon;
  final dynamic onTap;
  final dynamic hintText;
  final dynamic obscureText;
  final dynamic controller;
  final int? minLines;
  final bool readOnly;
  final bool isMobileNumber;
  final bool withValidate;
  final String? label;
  final IconData? labelIcon;
  final bool isRequired;
  final bool? digitOnly;
  final double? width;
  final double? height;
  final double? hintSize;
  final Function? onChanged;
  final Function? onComplete;

  final TextInputType? textInputType;
  final int? maxLength;
  final bool? isEnabled;
  final Color? labelColor;
  final double? vertical;
  final bool isOptional;
  final Widget? subLabel;

  const CustomTextField(
      {Key? key,
      this.validator,
      this.suffixIcon,
      this.hintText,
      this.obscureText,
      this.controller,
      this.readOnly = false,
      this.digitOnly = false,
      this.onChanged,
      this.textInputType,
      this.maxLength,
      this.onTap,
      this.label,
      this.isRequired = false,
      this.withValidate = false,
      this.isMobileNumber = false,
      this.width,
      this.hintSize,
      this.isEnabled,
      this.labelIcon,
      this.labelColor,
      this.height,
      this.minLines,
      this.subLabel,
      this.vertical, this.onComplete,  this.isOptional=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTablet =
        MediaQuery.of(MainUtils.navKey.currentContext!).size.shortestSide >=
            550;
    return Center(
      child: Stack(
        children: [
          TextFormField(
            minLines: minLines ?? 1,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
                fontSize:
                    isTablet ? size.height * 0.017 : size.height * 0.02,
                ),
            controller: controller,
            validator: withValidate && validator == null
                ? (value) {
                    if (value!.toString().trim().isEmpty) {
                      return getTranslated(context, "can_not_empty");
                    }
                    return null;
                  }
                : validator,
            onTap: onTap,
            obscureText: obscureText ?? false,
            readOnly: readOnly,
            keyboardType: digitOnly==true ? TextInputType.number : textInputType,
            onChanged: (str) =>
                onChanged != null ? onChanged!(str) : null,
            onEditingComplete:onComplete!=null?()=> onComplete!():null,
            cursorColor: kPrimaryColor,
            inputFormatters: digitOnly != null && digitOnly!
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    maxLength == null
                        ? LengthLimitingTextInputFormatter(999999)
                        : LengthLimitingTextInputFormatter(maxLength),
                  ]
                : [
                    maxLength == null
                        ? LengthLimitingTextInputFormatter(999999)
                        : LengthLimitingTextInputFormatter(maxLength),
                  ],
            decoration: InputDecoration(
              filled: false,
              isDense: true,
              isCollapsed: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabled: isEnabled ?? true,
              errorStyle: TextStyle(
                  fontSize: size.height * 0.013),
              fillColor: Colors.grey[300],
              labelText: label,
              labelStyle: TextStyle(
                fontSize: size.height*0.023,
                fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                color: Color(0xff090A0A)
              ),
              hintText: isMobileNumber && hintText == null
                  ? "7 ********"
                  : hintText,

              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: hintSize ?? size.height * 0.018,
              ),
              hoverColor: Colors.red,
              suffixIcon: isRequired
                  ?Text(
               "(${getTranslated(context, "required")!})",
               style: TextStyle(
                 fontSize: size.height*0.015,
               ),
              ):isOptional?Text(
                "(${getTranslated(context, "optional")!})",
                style: TextStyle(
                  fontSize: size.height*0.015,
                ),
              )
                  : suffixIcon != null
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(
                          end: size.width * 0.02),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(
                  maxHeight: size.height * 0.052,
                  minWidth: size.width * 0.05),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: size.height * 0.052),
              prefixIcon: isMobileNumber
                  ? Container(
                      margin: EdgeInsetsDirectional.only(
                          end: size.width * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02),
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.horizontal(
                            start: Radius.circular(size.height * 0.005)),
                        color: kPrimaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "+962",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.017),
                        ),
                      ),
                    )
                  : null,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder:  UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              prefix: Padding(
                padding:
                    EdgeInsetsDirectional.only(start: size.width * 0.025),
              ),
              contentPadding: EdgeInsetsDirectional.only(
                end: size.width * 0.025,
                bottom: vertical ?? size.height * 0.007,
                top: vertical ?? size.height * 0.007,
              ),
            ),
          ),


          // if (suffixIcon != null)
          //   Positioned.fill(
          //     child: Align(
          //       alignment: AlignmentDirectional.centerEnd,
          //       child: Padding(
          //         padding: EdgeInsetsDirectional.only(
          //           end: size.width * 0.03,
          //         ),
          //         child: suffixIcon,
          //       ),
          //     ),
          //   ),
          // if(isMobileNumber)
          //   Positioned.fill(
          //     child: Align(
          //       alignment: AlignmentDirectional.topStart,
          //       child: Container(
          //         constraints: BoxConstraints(
          //           maxHeight: size.height*0.05
          //         ),
          //         margin:
          //         EdgeInsetsDirectional.only(end: size.width * 0.02),
          //         padding:
          //         EdgeInsets.symmetric(horizontal: size.width * 0.02),
          //         width: size.width * 0.15,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadiusDirectional.horizontal(
          //               start: Radius.circular(size.height * 0.005)),
          //           color: kPrimaryColor,
          //         ),
          //         child: Center(
          //           child: Text(
          //             "+962",
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: size.height * 0.017),
          //           ),
          //         ),
          //       )
          //     ),
          //   )
        ],
      ),
    );
  }
}
