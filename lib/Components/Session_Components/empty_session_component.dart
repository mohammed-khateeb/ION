import 'package:flutter/material.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Widgets/custom_button.dart';

class EmptySessionComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  const EmptySessionComponent({Key? key, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: size.width*0.1
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty_session.png",
            height: size.height*0.3,),
          SizedBox(height: size.height*0.03,),

          Text(
            getTranslated(context, title)!,
            style: TextStyle(
                fontSize: size.height*0.025,
                fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height*0.02,),
          Text(
            getTranslated(context, subTitle)!,
            style: TextStyle(
                fontSize: size.height*0.017,
                color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height*0.02,),
          CustomButton(
            label: getTranslated(context, "book_now")!,
            width: size.width*0.4,
            onPressed: (){},
          )
        ],
      ),
    );
  }
}
