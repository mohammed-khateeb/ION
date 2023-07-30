import 'package:flutter/material.dart';
import 'package:ion_application/Localization/current_language.dart';
import 'package:ion_application/Models/Api/transactions.dart';
import 'package:ion_application/Utils/date_utils.dart';
import 'package:ion_application/Widgets/custom_button.dart';

import '../Localization/language_constants.dart';

class SessionCard extends StatelessWidget {
  final Transaction transaction;
  const SessionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: size.height*0.02
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.height*0.015),
        color: Colors.white,
        border: Border.all(color:transaction.source=="eFawateercom"?Colors.green: Colors.grey[600]!,width: 3),
        boxShadow: [
          BoxShadow(
              spreadRadius: 2,
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(-2,2)
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width*0.05,
        vertical: size.height*0.01
      ),
      child: Column(
        children: [
          SizedBox(height: size.height*0.01,),
          Row(
            children: [
              SizedBox(
                width: size.width*0.4,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '${getTranslated(context,"date")!} \n',
                    style:  TextStyle(
                        fontSize: size.height*0.017,
                        fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                        color: Colors.grey[800]
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: transaction.date!.dateTimeFormat(inArabic: !currentLanguageIsEnglish,withNewLine: false), style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font",height:!currentLanguageIsEnglish? 1.5:null,fontSize: size.height*0.018)),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height*0.06,
                width: 0.5,
                color: Colors.grey[350],
              ),
              SizedBox(width: size.width*0.03,),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${getTranslated(context,"time")!} \n',
                  style:  TextStyle(
                      fontSize: size.height*0.017,
                      fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                      color: Colors.grey[800]
                  ),
                  children:  <TextSpan>[
                    TextSpan(text: transaction.date!.timeFormat(inArabic: !currentLanguageIsEnglish), style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font",height: !currentLanguageIsEnglish? 1.5:null,fontSize: size.height*0.018)),
                  ],
                ),
              )
            ],
          ),
          Divider(color: Colors.grey[350],),
          Row(
            children: [
              Text(
                transaction.total!.toStringAsFixed(3),
                style: TextStyle(
                  fontSize: size.height*0.05,
                  fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                ),
              ),
              SizedBox(width: size.width*0.03,),
              Text(
                getTranslated(context, "jod")!,
                style: TextStyle(
                    fontSize: size.height*0.022,
                    fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Font"
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(transaction.kwh!=null)
                  Text(
                    "${transaction.kwh!.toStringAsFixed(3)} ${getTranslated(context, "kw")!}",
                    style: TextStyle(
                      fontSize: size.height*0.015
                    ),
                  ),

                ],
              )
            ],
          ),
          Divider(color: Colors.grey[350],),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: double.infinity,),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${getTranslated(context,"location")!}: ',
                  style:  TextStyle(
                      fontSize: size.height*0.015,
                      fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                      color: Colors.grey[800]
                  ),
                  children:  <TextSpan>[
                    TextSpan(text: transaction.source, style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font")),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: size.height*0.04,),
          // CustomButton(
          //   height: size.height*0.04,
          //     label: getTranslated(context, "share")!,
          //     onPressed: (){}
          // ),
          // SizedBox(height: size.height*0.015,),


        ],
      ),
    );
  }
}
