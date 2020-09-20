import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeStateInfo with ChangeNotifier, DiagnosticableTreeMixin {
  //DRAWER
  int _currentDrawer = 0;

  int get getCurrentDrawer => _currentDrawer;

  void setCurrentDrawer(int drawer) {
    _currentDrawer = drawer;
    notifyListeners();
  }

  //CHAT

  //--Controller
  final TextEditingController _inputController = TextEditingController();
  TextEditingController get getChatController => _inputController;

  void clearChatField() {
    _inputController.clear();
    notifyListeners();
  }

  //--LIST
  List _chats = [];
  List get getChats => _chats;

  /* For future work
  List<ModeloRespuestaBot> _botLog =[];
  List get getBotLog =>_botLog;

  void addToBotLog(ModeloRespuestaBot respuestaBot){
    _botLog.add(respuestaBot);
    notifyListeners();
  }*/

  void addMessage(string) {
    _chats.add(string);
    notifyListeners();
  }

  //--VISUAL
  bool _sePresionoBoton = true;
  bool get isChatOpened => _sePresionoBoton;

  bool _dioRespuestaBot = true;
  bool get responseFinished => _dioRespuestaBot;

  void handleChangeChat() {
    //String result = "Estaba en " + _sePresionoBoton.toString();
    _sePresionoBoton = !_sePresionoBoton;
    //result += " y quedo en " + _sePresionoBoton.toString();
    //print(result);
    notifyListeners();
  }

  void handleResponseChat() {
    //String resultRespuesta = "(RTA) Estaba en: " + _dioRespuestaBot.toString();
    _dioRespuestaBot = !_dioRespuestaBot;
    //resultRespuesta += " Y quedo en: " + _dioRespuestaBot.toString();

    //print(resultRespuesta);
    notifyListeners();

    if (_dioRespuestaBot) {
      requestFocus();
    }
  }

  //--FOCUS
  final FocusNode _focusNode = FocusNode();

  void requestFocus() {
    _focusNode.requestFocus();
    notifyListeners();
  }

  FocusNode get focus => _focusNode;

  void setTextContrroller(text) {
    _inputController.text = text;
    notifyListeners();
  }
}
