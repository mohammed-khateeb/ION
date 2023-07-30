import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ion_application/Widgets/custom_app_bar.dart';
import 'package:ion_application/Widgets/session_card.dart';
import 'package:ion_application/Widgets/waiting_widget.dart';
import 'package:provider/provider.dart';

import '../Components/Session_Components/empty_session_component.dart';
import '../Controller/transactions_controller.dart';
import '../Localization/language_constants.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Type selectedType = Type.previous;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated(context, "my_transactions"),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: size.width * 0.05, vertical: size.height * 0.01),
          //   child: Center(
          //     child: SizedBox(
          //       width: size.width,
          //       child: CupertinoSlidingSegmentedControl<Type>(
          //         backgroundColor: Colors.grey[300]!,
          //         thumbColor: Colors.white,
          //         groupValue: selectedType,
          //         onValueChanged: (Type? value) {
          //           if (value != null) {
          //             setState(() {
          //               selectedType = value;
          //             });
          //           }
          //         },
          //         children: <Type, Widget>{
          //           Type.current: Padding(
          //             padding:
          //             EdgeInsets.symmetric(vertical: size.height * 0.005),
          //             child: Text(
          //               getTranslated(context, "current")!,
          //               style: TextStyle(fontSize: size.height * 0.016,fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"),
          //             ),
          //           ),
          //           Type.previous: Text(
          //             getTranslated(context, "previous")!,
          //             style: TextStyle(fontSize: size.height * 0.016,fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"),
          //           ),
          //           Type.scheduled: Text(
          //             getTranslated(context, "scheduled")!,
          //             style: TextStyle(fontSize: size.height * 0.016,fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"),
          //           ),
          //         },
          //       ),
          //     ),
          //   ),
          // ),

          Expanded(
            child: Consumer<TransactionsController>(
              builder: (context,transactionsData,_) {
                return transactionsData.waiting?const WaitingWidget():transactionsData.transactions!.isEmpty
                    ?Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: size.height*0.1
                        ),
                        child: Text(
                  getTranslated(context, "no_transactions")!,
                  style: TextStyle(
                        fontSize: size.height*0.018
                  ),
                ),
                      ),
                    )
                    :ListView.builder(
                  itemCount: transactionsData.transactions!.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.05
                  ),
                  itemBuilder: (_,index){
                    return SessionCard(
                      transaction: transactionsData.transactions![index],
                    );
                  },
                );
              }
            ),
          )
        ],
      ),
    );
  }
}


enum Type { current, previous ,scheduled}

