import 'dart:convert';

import 'package:chatbot/components/BotonPersonalizado.dart';
import 'package:chatbot/pages/PaginaDeInicio.dart';
import 'package:chatbot/pages/PaginaDeRegistro.dart';
import 'package:chatbot/utils/providers/SessionStateInfo.dart';
import 'package:chatbot/utils/strings/serverData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../models/ModeloRespuestaLogin.dart';

class PaginaDeIngreso extends StatefulWidget {
  @override
  _PaginaDeIngresoState createState() => _PaginaDeIngresoState();
}

class _PaginaDeIngresoState extends State<PaginaDeIngreso> {
  Session usuario;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  http.Client client;
  @override
  void initState() {
    super.initState();
    client = http.Client();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final sessionStateInfo = Provider.of<SessionStateInfo>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: height,
          ),
          Container(
            width: width * 0.4,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    controller: _controllerPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Clave',
                        labelText: 'Clave',
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: BotonPersonalizado(
                      text: 'Ingresar',
                      onClick: () {
                        validateData(
                                _controllerEmail.text, _controllerPassword.text)
                            .then((value) {
                          if (value.hasData) {
                            print("Session es:"+value.session.toJson().toString());
                            sessionStateInfo.settearSesion(value.session)  ;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PaginaDeInicio()));
                          } else {
                            Toast.show('Datos erroneos', context);
                          }
                        });
                      },
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text('¿Olvido la clave?'),
                ),
                _divider(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('No tienes cuenta?'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Text(
                              'Registrate aqui',
                              style: TextStyle(color: const Color(0xfffe7f2d)),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PaginaDeRegistro()));
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Future<ModeloRespuestaLogin> validateData(email, clave) async {
    Uri url = Uri.http(SERVER,DIR_LOGIN,{
      'email' : email,
      'clave' : clave
    });

    final response = await client.get(url);

    ModeloRespuestaLogin tempR= ModeloRespuestaLogin(hasData: false,session: null);

    if (response.statusCode == 200) {
      tempR = ModeloRespuestaLogin.fromJson(json.decode(response.body));
    }
    return tempR;
  }
}
