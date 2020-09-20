import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FragmentoRedireccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = Provider.of<HomeStateInfo>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FutureBuilder(
          future: esperar(info),
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Obteniendo datos", style: TextStyle(fontSize: 20.0),),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                )
              ],
            );
          },
        ),
    );
  }

  Future esperar(info) async {
    Future.delayed(
        Duration(
          milliseconds: 500,
        ), () {
      info.setCurrentDrawer(1);
    });
  }
}
