import 'package:flutter/material.dart';
import '../Utils/color_utils.dart';
import '../Utils/main_utils.dart';
import 'custom_inkwell.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? action;
  final bool allowBack;

  final Function? onBack;
  final Color? elementColor;
  final Color? backgroundColor;

  const CustomAppBar({Key? key, this.title, this.action, this.allowBack = true, this.onBack, this.elementColor, this.backgroundColor})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTablet =
        MediaQuery.of(MainUtils.navKey.currentContext!).size.shortestSide >=
            550;
    return AppBar(
      elevation: 0,
      backgroundColor:backgroundColor?? Colors.transparent,
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: allowBack ? size.width * 0.18 : null,
      leading: allowBack
          ?
      CustomInkwell(
              onTap: () {
                Navigator.pop(context);
                if(onBack!=null){
                  onBack!();
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: size.height * 0.025,
                color:elementColor!=null?kPrimaryColor: Colors.black,
              ),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.only(top: isTablet ? size.height * 0.014 : 0),
        child:title!=null?
        Text(
          title!,
          style: TextStyle(
            fontSize: size.height*0.018,color:elementColor?? Colors.grey[800],fontWeight: FontWeight.bold
          ),
        )
            : const SizedBox()
      ),
      actions: [
        action != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: action!,
              )
            : const SizedBox()
      ],
    );
  }
}
