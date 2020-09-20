import 'package:chatbot/pages/PaginaDeIngreso.dart';
import 'package:chatbot/utils/providers/FacturasProvider.dart';
import 'package:chatbot/utils/providers/HomeStateInfo.dart';
import 'package:chatbot/utils/providers/SessionStateInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ),
  );
  runApp(MultiProvider(
    providers: [
       ChangeNotifierProvider<HomeStateInfo>(create: (context) => HomeStateInfo()),
       ChangeNotifierProvider<SessionStateInfo>(create: (context) => SessionStateInfo()),
       ChangeNotifierProvider<FacturasProvider>(create: (context) => FacturasProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Facturas por pagar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:PaginaDeIngreso()
      );
  }
}
