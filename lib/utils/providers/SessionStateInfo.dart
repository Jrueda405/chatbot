import 'package:chatbot/models/ModeloRespuestaLogin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SessionStateInfo with ChangeNotifier, DiagnosticableTreeMixin {

 Session _session;

 Session get obtenerSesion=>_session;

 void settearSesion(Session s){
   _session=s;
   notifyListeners();
 }

}
