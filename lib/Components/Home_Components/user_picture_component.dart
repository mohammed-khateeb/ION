import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Widgets/gradient_card.dart';
import '../../Widgets/reusable_cached_network_image.dart';

class UserPictureComponent extends StatelessWidget {
  final Function onTab;
  const UserPictureComponent({Key? key, required this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height*0.07,
      child: CustomInkwell(
        onTap: (){
          onTab();
        },
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start:size.height*0.05),
                child: GradientCard(
                  child: Container(
                    padding: EdgeInsetsDirectional.only(
                        top: size.height*0.011,
                        bottom: size.height*0.011,
                        end: size.width*0.03,
                        start: size.width*0.055
                    ),
                    child: Text(
                      "${getTranslated(context, "hi")}, ${CurrentUser.firstName}",
                      style: TextStyle(
                          fontSize: size.height*0.015,
                          fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font"
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Stack(
                  children: [
                    Container(
                      height: size.height*0.067,
                      width: size.height*0.067,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white,width:4),

                      ),
                      child:  Image.asset(
                        "assets/images/profile.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          height: size.height*0.02,
                          width: size.height*0.02,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white,width: 2)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
