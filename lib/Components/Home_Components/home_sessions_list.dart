import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ion_application/Components/Home_Components/pin_code_with_last_session.dart';
import 'package:ion_application/Controller/transactions_controller.dart';
import 'package:ion_application/Models/Api/transactions.dart';
import 'package:ion_application/Utils/date_utils.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Widgets/custom_page_view.dart';
import '../../Widgets/gradient_card.dart';
import '../../Widgets/waiting_widget.dart';

class HomeSessionList extends StatefulWidget {

  const HomeSessionList({Key? key,})
      : super(key: key);

  @override
  State<HomeSessionList> createState() => _HomeSessionListState();
}

class _HomeSessionListState extends State<HomeSessionList>  with TickerProviderStateMixin{
  final TransformerPageController _pageController = TransformerPageController(viewportFraction: 0.63);

  int currentIndex = 0;
  TabController? tabController;
  bool showIndicator = true;


  void _pageScrollListener() {
    if (_pageController.page!.round() != _pageController.page) {
      setState(() {
        showIndicator = true;
      });
    } else {
      setState(() {
        showIndicator = false;
      });
    }
  }


  @override
  void initState() {

    _pageController.addListener(_pageScrollListener);
    Future.delayed(Duration.zero).then((value) {
      context.read<TransactionsController>().waitTransaction().then((value) {
        context.read<TransactionsController>().getTransactions().then((value) {
          Future.delayed(Duration(milliseconds: 500)).then((value) {
            setState(() {
              showIndicator = false;
            });
          });
          tabController = TabController(length: context.read<TransactionsController>().transactions!.length>5?5:context.read<TransactionsController>().transactions!.length, vsync: this);
        });
      });
    });



    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: SizedBox(
        height: size.height * 0.17,
        width: size.width,
        child: Consumer<TransactionsController>(
            builder: (context, transactionsData, _) {
          return transactionsData.waiting
              ? const WaitingWidget()
              : transactionsData.transactions!.isEmpty
                  ? DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.grey[400]!,
            radius: Radius.circular(size.height*0.008),
            child: Center(
              child: Row(
                children: [
                  SizedBox(width: size.width*0.05,),
                  Text(
                    getTranslated(context, "no_charging_history")!,
                    style: TextStyle(
                      fontSize: size.height*0.02,
                      color: Colors.grey[400]
                    ),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),)
                  : SizedBox(
                      height: size.height * 0.17,
                      child: Stack(
                        children: [
                          TransformerPageView(
                            physics: CustomScrollPhysics(transactionsData.transactions!.length>5?6:transactionsData.transactions!.length+1),
                            itemCount: transactionsData.transactions!.length>5?6:transactionsData.transactions!.length+1,
                            pageController: _pageController,
                            onPageChanged: (int? index){
                              setState(() {
                                tabController?.index = index!;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height*0.01
                                ),
                                child:  GradientCard(
                                  isTransparent: true,
                                  borderRadiusValue: 0,
                                ),
                              );
                            },
                            transactions: transactionsData.transactions,
                            transformer: ScaleAndFadeTransformer(),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: showIndicator?1:0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SmoothPageIndicator(
                                  controller: _pageController,  // PageController
                                  count:  transactionsData.transactions!.length>5?5:transactionsData.transactions!.length,
                                  effect:   WormEffect(
                                    radius: 0,
                                    dotHeight: size.height*0.002,
                                    spacing: 0,
                                    offset: 0,
                                    dotWidth: (size.width/(transactionsData.transactions!.length>5?5:transactionsData.transactions!.length))-(size.width * 0.005*(transactionsData.transactions!.length>5?5:transactionsData.transactions!.length)),
                                    activeDotColor: kPrimaryColor,
                                    dotColor: Colors.grey[400]!,
                                  ),  // your preferred effect
                              ),
                            ),
                          )
                        ],
                      )
                    );
        }),
      ),
    );
  }


}
class ScaleAndFadeTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info,List<Transaction> transactions) {
    double? position = info.position;
    int index = info.index!;

    double scale = 1.0 - (position!.abs() * 0.48);
    Transaction transaction = transactions[index];
    BuildContext context = MainUtils.navKey.currentContext!;
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Transform.translate(
          offset: Offset(position*(size.width*0.1*(currentLanguageIsEnglish?-1:1)),0),
          child: Transform.scale(
            scaleX:index==5?0.5:scale,
            scaleY: 0.9,
            child: GradientCard(
                borderRadiusValue: size.height*0.01,
                child: child
            ),
          ),
        ),
        if(index==5)
          Transform.scale(
            scaleY: 0.9,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: size.width*0.235,start: size.width*0.035,),
              child: CustomInkwell(
                onTap: (){
                  CustomFocusManager.pinCodeFocusNode.unfocus();

                  NavigatorUtils.navigateToSessionScreen(context);
                },
                child: GradientCard(
                  isBlack: true,
                  borderRadiusValue: size.height*0.01,
                  child: Center(
                    child: Text(
                      getTranslated(context, "see_more")!,
                      style: TextStyle(
                          fontSize: size.height*0.025,
                          color: Colors.blue
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),

        Padding(
          padding: EdgeInsetsDirectional.only(
              start:index==5?size.width*0.11: size.width * 0.06),
          child:index==5
              ?const SizedBox()
              : Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      index == 0
                          ? getTranslated(
                          context,
                          "last_session")!
                          : transaction
                          .date!
                          .dateTimeFormat(
                          inArabic:
                          !currentLanguageIsEnglish),
                      style: TextStyle(
                          fontSize:
                          size.height *
                              0.018,
                          color: Colors.grey[600]),
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                "${transaction.total!.toStringAsFixed(1)} ${getTranslated(context, "jod")!}",
                style: TextStyle(
                    fontSize:
                    size.height * (currentLanguageIsEnglish?0.02:0.017),
                    color: Colors.black,
                    fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Font"),
              ),
              if (transaction
                  .kwh !=
                  null)
                Text(
                  "${transaction.kwh!.toStringAsFixed(2)} ${getTranslated(context, "kw")!}",
                  style: TextStyle(
                    fontSize:
                    size.height * (currentLanguageIsEnglish?0.02:0.017),
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final int count;
  CustomScrollPhysics(this.count,  {ScrollPhysics? parent}) : super(parent: parent);

  bool isGoingRight = true;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(count,parent: buildParent(ancestor)!);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingRight = offset.sign > 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent)
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value)
      // overscroll
      return value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge

      return value - position.minScrollExtent;

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;

    if(value>getPositionFromCount(count)&&position.pixels<value){
      return  value-position.pixels;
    }

    return 0.0;
  }

  getPositionFromCount(int count){
    switch(count) {
      case 1:
        return 0;
      case 2:
        return 0;
      case 3:
        return MediaQuery.of(MainUtils.navKey.currentContext!).size.width*0.58;
      case 4:
        return MediaQuery.of(MainUtils.navKey.currentContext!).size.width*1.15;
      case 5:
        return MediaQuery.of(MainUtils.navKey.currentContext!).size.width*1.7;
      case 6:
        return MediaQuery.of(MainUtils.navKey.currentContext!).size.width*2.27;

      default:
        print('choose a different number!');
    }
  }

}

