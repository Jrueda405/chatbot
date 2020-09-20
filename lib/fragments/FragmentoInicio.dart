import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const textTitleStyle = TextStyle(fontSize: 28, fontWeight: FontWeight.w600);
const secondaryTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
const secondaryTextStyleWhite =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400);

class FragmentoInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = Provider.of<HomeStateInfo>(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image(
                image: AssetImage('assets/images/logo_unab.png'),
              ),
              ),
              Text(
                'Bienvenido al portal de autogestión de facturas por pagar de la Universidad Autonoma De Bucaramanga',
                textAlign: TextAlign.center,
                style: textTitleStyle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text('Nos alegra tenerte por aquí',
                  style: secondaryTextStyle),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  onPressed: () {
                    info.setTextContrroller('¿Como puedes ayudarme?');
                    info.requestFocus();
                    //info.handleChangeChat(); descomentar en caso que este oculto el chat
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 0.0,
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [Colors.orange, Colors.purple]),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        'COMENZAR',
                        style: secondaryTextStyleWhite,
                      ),
                    ),
                  )),
              
            ],
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 0,
          right: 0,
          child: Text(
            'Desarrollado por Julian Nieto',
            textAlign: TextAlign.center,
            style: secondaryTextStyle,
          ),
        ),
      ],
    );
  }
}
