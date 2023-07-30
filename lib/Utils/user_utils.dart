import 'package:firebase_auth/firebase_auth.dart' as userAuth;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/auth_controller.dart';
import '../Localization/current_language.dart';
import '../Localization/language_constants.dart';
import '../Models/Api/current_user.dart';
import '../Models/Api/user.dart';
import 'main_utils.dart';


class UserUtils {
  static SharedPreferences? preferences;

  static bool firstUse = true;

  static initCurrentUser(User user) async {
    CurrentUser.firstName = user.firstName;

    CurrentUser.fcmToken = user.fcmToken;
    await fetchUserInformationToShared();
  }

  static checkFirstTimeUseApp() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences!.getBool("first_use") != null) {
      firstUse = preferences!.getBool("first_use")!;
    }
  }

  static updateFirstUse(bool value) async {
    preferences = await SharedPreferences.getInstance();

    preferences!.setBool("first_use", value);
  }

   static Future updateCurrentUserToken(String token,{bool directly = true})async{
    CurrentUser.token = token;
    if(directly) {
      await fetchTokenToShared();
    }
    else{
      await fetchTokenToFirstShared();
    }
  }


  static Future updateCurrentUserTokenFromFirstToken()async{
    if (preferences?.getString("first_token") != null) {
      preferences!.setString("token", preferences!.getString("first_token")!);
    }
  }

  static Future<void> fetchUserInformationToShared() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences?.getString("first_token") != null) {
      preferences!.setString("token", preferences!.getString("first_token")!);
    }

    if (CurrentUser.firstName != null) {
      preferences!.setString("first_name", CurrentUser.firstName!);
    }

    if (CurrentUser.fcmToken != null) {
      preferences!.setString("fcm_token", CurrentUser.fcmToken!);
    }

    await preferences!.commit();
  }
  static Future<void> fetchTokenToFirstShared() async {
    preferences = await SharedPreferences.getInstance();

    if (CurrentUser.token != null) {
      preferences!.setString("first_token", CurrentUser.token!);
    }

    await preferences!.commit();
  }

  static Future<void> fetchTokenToShared() async {
    preferences = await SharedPreferences.getInstance();

    if (CurrentUser.token != null) {
      preferences!.setString("token", CurrentUser.token!);
    }

    await preferences!.commit();
  }

  static Future<bool> checkToken(String token)async{
    bool tokenIsValid = await MainUtils.navKey.currentContext!.read<AuthController>().checkToken(token);
    print("token = $token");
    print("token is valid : $tokenIsValid");
    return tokenIsValid;
  }

  static  Future<void> checkTokenValidation({required Function afterCheck,bool withLoading = true})async{
    if(withLoading) {
      MainUtils.showWaitingProgressDialog();
    }

    bool tokenIsValid = await checkToken(CurrentUser.token!);
    if(withLoading) {
      MainUtils.hideWaitingProgressDialog();
    }
    if(tokenIsValid){
      afterCheck();
    }
    else{
      MainUtils.showWaitingProgressDialog();
      await userAuth.FirebaseAuth.instance.currentUser?.reload();
      String? refreshToken = await userAuth.FirebaseAuth.instance.currentUser?.getIdToken();
      print("////new token = $refreshToken");
      await UserUtils.updateCurrentUserToken(refreshToken!);
      await UserUtils.fetchUserInformationFromSharedToSingletonClass();
      afterCheck();
      MainUtils.hideWaitingProgressDialog();
    }

  }



  static Future<void> fetchUserInformationFromSharedToSingletonClass() async {
    preferences = await SharedPreferences.getInstance();
    String? token = preferences!.getString("token");
    String? fcmToken = preferences!.getString("fcm_token");
    String? firstName = preferences!.getString("first_name");

    CurrentUser.token = token;
    CurrentUser.fcmToken = fcmToken;
    CurrentUser.firstName = firstName;

  }



  static Future<void> signOut() async {
    SharedPreferences preferences;

    preferences = await SharedPreferences.getInstance();
    bool? firstUse = preferences.getBool("first_use");

    await preferences.clear();

    preferences.setString(LAGUAGE_CODE, currentLanguageIsEnglish?"en":"ar");
    if(firstUse!=null){
      preferences.setBool("first_use", firstUse);
    }

    CurrentUser.token = null;
    CurrentUser.firstName = null;
    CurrentUser.fcmToken = null;
  }
}
