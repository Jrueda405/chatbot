import 'dart:convert';
import 'package:chatbot/models/ModeloFactura.dart';
import 'package:chatbot/models/ModeloRespuestaLogin.dart';
import 'package:chatbot/utils/providers/FacturasProvider.dart';
import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:chatbot/utils/strings/serverData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FragmentoFacturas extends StatefulWidget {
  final Session s;
  final numFactura;
  final startDate;
  final endDate;
  const FragmentoFacturas(
      {Key key,
      @required this.s,
      this.startDate,
      this.endDate,
      this.numFactura})
      : super(key: key);
  @override
  _FragmentoFacturasState createState() => _FragmentoFacturasState();
}

class _FragmentoFacturasState extends State<FragmentoFacturas> {
  Future future;

  TextEditingController _controller = TextEditingController();
  List<Facturas> registroFacturas;

  int sortColumnIndex = 0;
  bool sortingAsc = true; //true ordena de menor a mayor (ASC) y false (DESC)
  @override
  void initState() {
    super.initState();
    registroFacturas = List<Facturas>();

    if (widget.endDate != null && widget.startDate != null) {
      //Se llamo la busqueda por fechas
      future = consultarFactura({
        'fechai': widget.startDate,
        'fechaf': widget.endDate,
        'documento': widget.s.numeroDocumento
      });
    } else if (widget.numFactura != null) {
      //se llamo la busqueda por factura
      future = consultarFactura({
        'documento': widget.s.numeroDocumento,
        'factura': widget.numFactura
      });
    } else {
      //busque todas sus facturas
      future = consultarFactura({
        'documento': widget.s.numeroDocumento,
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateInfo = Provider.of<HomeStateInfo>(context);
    final facturasInfo = Provider.of<FacturasProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Colors.purple),
                      ),
                      hintText: 'Buscar factura...'),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: Icon(Icons.search, color: Colors.purple),
                    onPressed: () {
                      facturasInfo.asignarNumeroFactura(_controller.text);
                      homeStateInfo.setCurrentDrawer(-5);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: future,
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.done) {
                  ModeloFactura datos = dataSnapshot.data;
                  if (datos.hasData) {
                    registroFacturas = datos.facturas;
                  }
                  return Expanded(
                    child: DataTable(
                        columnSpacing: 10.0,
                        sortAscending: sortingAsc,
                        sortColumnIndex: sortColumnIndex,
                        dividerThickness: 5.0,
                        columns: [
                          DataColumn(
                              onSort: (columnIndex, isAscending) {
                                print(isAscending);
                                sortColumnIndex = columnIndex;
                                sortingAsc = isAscending;
                                setState(() {
                                  if (sortingAsc) {
                                    registroFacturas.sort((a, b) =>
                                        b.factura.compareTo(a.factura));
                                  } else {
                                    registroFacturas.sort((a, b) =>
                                        a.factura.compareTo(b.factura));
                                  }
                                });
                              },
                              label: Text(
                                'Numero',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          DataColumn(
                              onSort: (columnIndex, isAscending) {
                                sortColumnIndex = columnIndex;
                                sortingAsc = isAscending;
                                setState(() {
                                  if (sortingAsc) {
                                    registroFacturas.sort((a, b) =>
                                        DateTime.parse(a.fecha).compareTo(
                                            DateTime.parse(b.fecha)));
                                  } else {
                                    registroFacturas.sort((a, b) =>
                                        DateTime.parse(b.fecha).compareTo(
                                            DateTime.parse(a.fecha)));
                                  }
                                });
                              },
                              label: Text('Fecha',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          DataColumn(
                              onSort: (columnIndex, isAscending) {
                                sortColumnIndex = columnIndex;
                                sortingAsc = isAscending;
                                setState(() {
                                  if (sortingAsc) {
                                    registroFacturas.sort(
                                        (a, b) => a.valor.compareTo(b.valor));
                                  } else {
                                    registroFacturas.sort(
                                        (a, b) => b.valor.compareTo(a.valor));
                                  }
                                });
                              },
                              label: Text('Valor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          DataColumn(
                              label: Text('Descripción',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          DataColumn(
                              label: Text('Estado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          DataColumn(
                              onSort: (columnIndex, isAscending) {
                                sortColumnIndex = columnIndex;
                                sortingAsc = isAscending;
                                setState(() {
                                  if (sortingAsc) {
                                    registroFacturas.sort((a, b) =>
                                        DateTime.parse(a.fechapago).compareTo(
                                            DateTime.parse(b.fechapago)));
                                  } else {
                                    registroFacturas.sort((a, b) =>
                                        DateTime.parse(b.fechapago).compareTo(
                                            DateTime.parse(a.fechapago)));
                                  }
                                });
                              },
                              label: Text('Fecha pago',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ],
                        rows: registroFacturas
                            .map((e) => DataRow(cells: [
                                  DataCell(Text(e.factura)),
                                  DataCell(Text(e.fecha)),
                                  DataCell(Text(e.valor.toString())),
                                  DataCell(Text(e.descripcion)),
                                  DataCell(Text(e.estado)),
                                  DataCell(Text(e.fechapago)),
                                ]))
                            .toList()),
                    flex: 1,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ],
    );
  }

  Future<ModeloFactura> consultarFactura(Map<String, String> mapa) async {
    print("parametros: " + mapa.toString());
    Uri url = Uri.http(SERVER, DIR_CONSULTAR_FACTURA, mapa);

    ModeloFactura modeloFactura = ModeloFactura(hasData: false, facturas: null);
    http.Response r = await http.get(url);
    //print("llego del servidor: " + r.body);
    if (r.statusCode == 200) {
      modeloFactura = ModeloFactura.fromJson(jsonDecode(r.body));
    }

    if (modeloFactura.facturas != null) {
      modeloFactura.facturas = modeloFactura.facturas
        ..sort((a, b) => b.factura.compareTo(a.factura));
    }

    return modeloFactura;
  }
}
