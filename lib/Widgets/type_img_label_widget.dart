import 'package:flutter/material.dart';

import '../Localization/current_language.dart';

class TypeImgLabelWidget extends StatelessWidget {
  final String type;
  const TypeImgLabelWidget({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.height*0.004),
        border: Border.all(color: Colors.black)
      ),
      padding: EdgeInsets.all(size.height*0.002),
      margin: EdgeInsets.all(size.width*0.005,),
      child: Column(
        children: [
          Image.asset(
            "assets/icons/filter_type_$type.png",
            height: size.height*0.025,
          ),
          SizedBox(height: size.height*0.005,),
          Text(
            type,
            style: TextStyle(
              fontSize: size.height*0.009,
              fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font"
            ),
          )
        ],
      ),
    );
  }
}
