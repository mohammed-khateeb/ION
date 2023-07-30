
import 'package:flutter/material.dart';
import 'package:ion_application/Services/version_services.dart';

import '../Models/Responses/httpresponse.dart';

class VersionController with ChangeNotifier {

///if false need update
  Future<bool> checkVersion() async {
    final VersionServices versionServices = VersionServices();
    HttpResponse<bool> response = await versionServices.checkVersion();
    return response.data ?? true;
  }
}
