import 'package:chatbot/components/ContenedorChat.dart';
import 'package:chatbot/fragments/FragmentoInicio.dart';
import 'package:chatbot/fragments/FragmentoPerfil.dart';
import 'package:chatbot/fragments/FragmentoFacturas.dart';
import 'package:chatbot/fragments/FragmentoRedireccion.dart';

import 'package:chatbot/utils/providers/FacturasProvider.dart';
import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:chatbot/utils/providers/SessionStateInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PaginaDeIngreso.dart';

class PaginaDeInicio extends StatefulWidget {
  
  const PaginaDeInicio({Key key}) : super(key: key);
  @override
  _PaginaDeInicioState createState() => _PaginaDeInicioState();
}

class _PaginaDeInicioState extends State<PaginaDeInicio>
    with TickerProviderStateMixin {
  ScrollController _scrollController;

  @override
  initState() {
    super.initState();
    this._scrollController = ScrollController();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var width = MediaWidgetInicioontext).size.width;
    //var height = MediaQuery.of(context).size.height;
    final homeStateInfo = Provider.of<HomeStateInfo>(context);
    final facturasInfo = Provider.of<FacturasProvider>(context);
    final sessionStateInfo = Provider.of<SessionStateInfo>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Proveedores',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.orange,
        ),
        drawer: Drawer(
          elevation: 3.0,
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xfffe7f2d),
                        onPressed: () {
                          homeStateInfo.setCurrentDrawer(-1);
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        sessionStateInfo.obtenerSesion.nombre,
                        style: secondaryTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Inicio',
                  style: secondaryTextStyle,
                ),
                hoverColor: Colors.orangeAccent[100],
                onTap: () {
                  homeStateInfo.setCurrentDrawer(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Buscar Factura',
                  style: secondaryTextStyle,
                ),
                hoverColor: Colors.orangeAccent[100],
                onTap: () {
                  homeStateInfo.setCurrentDrawer(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Cerrar sesión',
                  style: secondaryTextStyle,
                ),
                hoverColor: Colors.orangeAccent[100],
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaDeIngreso()));
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            buildContent(homeStateInfo.getCurrentDrawer, facturasInfo, sessionStateInfo),
            AnimatedPositioned(
              child: ContenedorChat(
                height: 350,
                width: 300,
                scrollController: _scrollController,
              ),
              duration: Duration(seconds: 1),
              bottom: 10,
              right: homeStateInfo.isChatOpened ? 5 : -500,
            ),
            //se pone aquí el botón por cuestiones de manejar el estado
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              right: 10,
              bottom: homeStateInfo.isChatOpened ? -500 : 10,
              child: RawMaterialButton(
                onPressed: () {
                  homeStateInfo.requestFocus();
                  homeStateInfo.handleChangeChat();
                },
                elevation: 3.0,
                fillColor: Colors.orange,
                child: Icon(
                  Icons.chat_bubble_rounded,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          ],
        ));
  }

  Widget buildContent(pos, facturasInfo, sessionInfo) {
    switch (pos) {
      case 0:
        return FragmentoInicio();
        break;
      case 1:
        return FragmentoFacturas(
            s: sessionInfo.obtenerSesion,
            numFactura: facturasInfo.numeroFactura,
            startDate: facturasInfo.fechaInicio,
            endDate: facturasInfo.fechaFin);
        break;
        case -5: return FragmentoRedireccion();
        break;
      default:
        return FragmentoPerfil(s: sessionInfo.obtenerSesion,);
        break;
    }
  }
}
