import 'dart:convert';

import 'package:chatbot/components/BotonPersonalizado.dart';
import 'package:chatbot/models/ModeloDocumento.dart';
import 'package:chatbot/utils/strings/serverData.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../models/ModeloRespuestaLogin.dart';

class PaginaDeRegistro extends StatefulWidget {
  @override
  _PaginaDeRegistroState createState() => _PaginaDeRegistroState();
}

class _PaginaDeRegistroState extends State<PaginaDeRegistro> {

  DatosDocumento category;
  List<DatosDocumento> documents;

  var password = TextEditingController();
  var email = TextEditingController();
  var name = TextEditingController();
  var document = TextEditingController();

  http.Client client;

  Future futureDocs;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    futureDocs = consultarTipoDocumentos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: height,
          ), //to fill parent without use expand function from Stack Widget
          Container(
            width: width * 0.4,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Registrarse'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            hintText: 'Nombre',
                            labelText: 'Nombre',
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        decoration: InputDecoration(
                            hintText: 'Clave',
                            labelText: 'Clave',
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                      ),
                    ),
                    FutureBuilder(
                      future: futureDocs,
                      builder: (context, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.done) {
                            documents=dataSnapshot.data;
                            category=documents.first;
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: DropdownButtonFormField(
                            value: category,
                            items: documents
                                .map((e) => new DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: <Widget>[
                                        Text(e.tipoDocumento),
                                      ],
                                    )))
                                .toList(),
                            onChanged: (newValue) {
                              setState(() => category = newValue);
                            },
                            decoration: InputDecoration(
                                hintText: 'Tipo de documento',
                                labelText: 'Tipo de documento',
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true),
                          ),
                        );
                      }else{
                        return SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextFormField(
                        controller: document,
                        decoration: InputDecoration(
                            hintText: 'Documento',
                            labelText: 'Documento',
                            border: InputBorder.none,
                            fillColor: Color(0xfff3f3f4),
                            filled: true),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: BotonPersonalizado(
                          text: 'Registrar',
                          onClick: () {
                            Session u = Session(
                                idUsuario: "",
                                nombre: name.text,
                                correo: email.text,
                                clave: password.text,
                                tipoDocumento: category.idDocumento,
                                numeroDocumento: document.text);
                            
                            registrarUsuario(u).then((value) {
                              if (value) {
                                Navigator.pushReplacementNamed(
                                    context, '/homePage',
                                    arguments: u);
                              }
                            });
                          },
                        )),
                  ],
                ),
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
                          child: Text('Ya tienes cuenta?'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Text(
                              'Ingresa',
                              style: TextStyle(
                                color: const Color(0xfffe7f2d),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
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

  Future<bool> registrarUsuario(Session s) async {
    bool isValidSession = false;
    Uri url = Uri.http(SERVER, DIR_REGISTRAR);
    try {
      final response = await client.post(url,
          body: {
            "correo":s.correo,
            "nombre":s.nombre,
            "clave":s.clave,
            "tipoDocumento":category.idDocumento,
            "numeroDocumento":s.numeroDocumento,
          },
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          );

      print(response.body);

      if (response.statusCode == 200) {
        if (response.body.contains("OK")) {
          isValidSession = true;
        } else {
          Toast.show("Ocurrio un problema", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return isValidSession;
  }

  Future<List<DatosDocumento>> consultarTipoDocumentos() async {
    List<DatosDocumento> lista = List<DatosDocumento>();
    Uri url = Uri.http(SERVER, DIR_CONSULTAR_TIPO_DOCUMENTO);
    try {
      final response = await client.get(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200) {
        ModeloDocumento modelo=ModeloDocumento.fromJson(jsonDecode(response.body));
        lista=modelo.data;
      }
    } catch (e) {
      print(e.toString());
    }
    return lista;
  }
}
