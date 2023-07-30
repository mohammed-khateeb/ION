import 'package:flutter/material.dart';
import 'package:ion_application/Localization/current_language.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Utils/color_utils.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_button.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';

import '../Components/tutorial_component.dart';
import '../Utils/user_utils.dart';

class TutorialScreen extends StatefulWidget {
  final bool fromHome;
  const TutorialScreen({Key? key, required this.fromHome}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [1,2,3,4,5,6].map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width*0.05
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03 + topPadding,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/user.png",
                      height: size.height*0.02,
                    ),
                    SizedBox(width: size.width*0.02,),
                    Text(
                      getTranslated(context, "user_tutorial")!,
                      style: TextStyle(
                        fontSize: size.height*0.02,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    if(e==1)
                    Image.asset(
                      "assets/images/logo.png",
                      height: size.height*0.06,
                    ),
                    if(e>1)
                      Container(
                        padding: EdgeInsets.all(size.height*0.01),
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor,width: 3),
                          shape: BoxShape.circle
                        ),
                        child: Text(
                          "${e-1}",
                          style: TextStyle(
                            fontSize: size.height*0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(child: TutorialComponent(index: e, pageController: pageController,)),
                if(e==1||e==6)
                CustomButton(
                  width: size.width*0.85,
                  label:e==1? getTranslated(context, "get_started")!:getTranslated(context, "done")!,
                  onPressed: (){
                    if(e==6){
                      UserUtils.updateFirstUse(false);
                      if(widget.fromHome){
                        Navigator.pop(context);
                      }
                      else{
                        NavigatorUtils.navigateToHomeScreen(context);
                      }
                    }
                    else{
                      pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                    }
                  },
                ),
                if(e!=6&&e!=1)
                Row(
                  children: [
                    SizedBox(
                      width: size.width*0.4,
                      child: Center(
                        child: CustomInkwell(
                          onTap: (){
                            UserUtils.updateFirstUse(false);
                            if(widget.fromHome){
                              Navigator.pop(context);
                            }
                            else{
                              NavigatorUtils.navigateToHomeScreen(context);
                            }

                          },
                          child: Text(
                            getTranslated(context, "skip")!,
                            style: TextStyle(
                              fontSize: size.height*0.022,
                              fontFamily: currentLanguageIsEnglish?"Bold":"Arabic_Bold",
                              color: kPrimaryColor
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:  CustomButton(
                        label:getTranslated(context, "next")!,
                        onPressed: (){
                          pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height*0.05,)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
