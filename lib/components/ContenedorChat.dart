import 'dart:convert';
import 'package:chatbot/models/ModeloRespuestaBot.dart' as DialogFlowResponse;
import 'package:chatbot/utils/providers/FacturasProvider.dart';
import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:chatbot/utils/strings/serverData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'BurbujaDeChat.dart';

class ContenedorChat extends StatelessWidget {
  
  final height;
  final width;
  final ScrollController scrollController;

  ContenedorChat(
      {Key key, this.height, this.width, @required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final HomeStateInfo info = Provider.of<HomeStateInfo>(context);
    final FacturasProvider facturasInfo =
        Provider.of<FacturasProvider>(context);
    return Stack(children: [
      Container(
        height: height,
        width: width,
        child: Card(
          elevation: 5.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(flex: 0, child: chatBar(info)),
              Flexible(
                flex: 10,
                child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index % 2 == 0) {
                      return Padding(
                        child: rightWidget(info.getChats[index]),
                        padding: EdgeInsets.all(5.0),
                      );
                    } else {
                      return Padding(
                        child: leftWidget(info.getChats[index], info, facturasInfo, index),
                        padding: EdgeInsets.all(5.0),
                      );
                    }
                  },
                  itemCount: info.getChats.length,
                ),
              ),
              Flexible(
                  flex: 0,
                  child: bottomChatComponent(info, context, facturasInfo))
            ],
          ),
        ),
      ),
      AnimatedPositioned(
        child: Align(
          child: CircularProgressIndicator(),
          alignment: Alignment.center,
        ),
        duration: Duration(milliseconds: 500),
        left: 0,
        right: 0,
        bottom: !info.responseFinished ? height * 0.15 : -500,
      ),
    ]);
  }

  Widget leftWidget(string, HomeStateInfo info, FacturasProvider facturasInfo, int position) {
    return InkWell(
      onTap: ((facturasInfo.fechaFin!=null || facturasInfo.fechaInicio!=null) || facturasInfo.numeroFactura!=null )
            && info.getChats.length-1==position
          ? () {
              info.setCurrentDrawer(-5);
            }
          : null,
      child: Align(
        alignment: Alignment.topLeft,
        child: CustomPaint(
          painter:
              BurbujaDeChat(color: Colors.amber, alignment: Alignment.topLeft),
          child: Container(
            margin: EdgeInsets.only(left: 15.0, bottom: 7, top: 7, right: 10),
            child: Stack(
              children: <Widget>[
                Text(string),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rightWidget(string) {
    return Align(
      alignment: Alignment
          .topRight, //Change this to Alignment.topRight or Alignment.topLeft
      child: CustomPaint(
        painter:
            BurbujaDeChat(color: Colors.purple, alignment: Alignment.topRight),
        child: Container(
          margin: EdgeInsets.only(left: 10.0, bottom: 7, top: 7, right: 15.0),
          child: Stack(
            children: <Widget>[
              Text(
                string,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBar(info) {
    return Container(
        width: width,
        padding: EdgeInsets.only(
          left: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bot',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () {
                    info.handleChangeChat();
                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget bottomChatComponent(info, context, facturasInfo) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              enabled: info.responseFinished,
              controller: info.getChatController,
              onSubmitted: (val) {
                handleSent(info, context, facturasInfo);
              },
              textInputAction: TextInputAction.go,
              focusNode: info.focus,
              decoration: InputDecoration(
                hintText: 'Escribe...',
                border: OutlineInputBorder(),
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => handleSent(info, context, facturasInfo),
            ),
          ),
        ],
      ),
    );
  }

  void scrollToBottom(ScrollController _scrollController) {
    final bottomOffset = _scrollController.position.maxScrollExtent + 200;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
  }

  Future<String> enviarMensaje(String mensaje, facturasInfo) async {
    //Uri url = Uri.http(SERVER, DIR_PHP_CHATBOT, {'mensaje': mensaje});
    Uri url =
        Uri.http("192.168.5.185:80", DIR_PHP_CHATBOT, {'mensaje': mensaje});

    http.Response r = await http.get(url);
    if (r.statusCode == 200) {
      var payload = jsonDecode(r.body);

      var parameters = payload['parameters'];



      if (parameters.toString().contains("number")) {
        //{number: [12344223]}
        String numeroFactura = parameters
            .toString()
            .substring(0, parameters.toString().length - 2);
        numeroFactura = numeroFactura.split("[").last;

        facturasInfo.asignarNumeroFactura(numeroFactura);
      } else if (parameters.toString().contains("startDate") ||
          parameters.toString().contains("endDate")) {

        facturasInfo.asignarFechaInicio(parameters['date-period']['startDate']);
        facturasInfo.asignarFechaFin(parameters['date-period']['endDate']);
      } else {
        facturasInfo.limpiarBusquedaFacturas();
      }

      var data = DialogFlowResponse.ModeloRespuestaBot.fromJson(payload);

      return data.fulfillmentText;
    }
    return null;
  }

  handleSent(HomeStateInfo info, context, facturasInfo) {
    info.handleResponseChat();
    var texto = info.getChatController.text;
    info.clearChatField();
    this.enviarMensaje(texto, facturasInfo).then((String val) {
      if (val != null) {
        info.addMessage(texto);
        info.addMessage(val);
        scrollToBottom(scrollController);
      } else {
        info.setTextContrroller(texto);
      }
    }).whenComplete(() {
      info.handleResponseChat(); //intentemos poner esto en la comparacion !=null y aqui pedir el focus
    });
  }
}
