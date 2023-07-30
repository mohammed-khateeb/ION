import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ion_application/Components/drawer_component.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:ion_application/Screens/map_screen.dart';
import 'package:ion_application/Widgets/gradient_card.dart';
import 'package:provider/provider.dart';
import '../Components/Home_Components/find_a_charger_with_plan_trip_component.dart';
import '../Components/Home_Components/home_actve_sessions.dart';
import '../Components/Home_Components/home_sessions_list.dart';
import '../Components/Home_Components/pin_code_with_last_session.dart';
import '../Components/Home_Components/user_picture_component.dart';
import '../Components/Home_Components/web_view_component.dart';
import '../Controller/transactions_controller.dart';
import '../Utils/main_utils.dart';
import '../Utils/mqtt_handler.dart';
import '../Utils/navigtor_utils.dart';
import '../Utils/user_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthController>().getProfile().then((value) {
      String mobileNumber = context.read<AuthController>().user!.mobileNumber!.replaceAll("+", "");
      context.read<MqttHandler>().connect(mobileNumber);
    });


    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }











  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // Handle the app lifecycle state change
    switch (state) {
      case AppLifecycleState.resumed:
        await UserUtils.checkTokenValidation(
          afterCheck: (){
            NavigatorUtils.navigateToHomeScreen(MainUtils.navKey.currentContext!);
          },
          withLoading: false
        );
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }





  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer:  DrawerComponent(scaffoldKey: _scaffoldKey,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.04 + topPadding,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserPictureComponent(
                    onTab: (){
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    height: size.height * 0.05,
                  )
                ],
              ),
            ),
            FindAChargerWithPlanTripComponent(),
            SizedBox(height: size.height * 0.005),
            const PinCodeWithLastSession(

            ),
            // HomeActiveSessionList(
            //   mqttHandler: mqttHandler,
            //   expandableController: activeSessionController,
            // ),
            SizedBox(height: size.height * 0.02),
            const HomeSessionList(),
            SizedBox(height: size.height * 0.02),
            WebViewComponent(),
            //MyCarComponent(),
          ],
        ),
      ),
    );
  }
}
