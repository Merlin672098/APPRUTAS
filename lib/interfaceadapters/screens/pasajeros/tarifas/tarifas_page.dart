import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutasmicros/pruebaprovider.dart';

class TarifasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.white, 
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            appBar: AppBar(
              title: Text('TARIFAS DE TRANSPORTE PÚBLICO'),
            ),
            body: _buildPageContent(context, themeProvider.isDarkModeEnabled),
          ),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, bool isDarkMode) {
  Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
  Color textColor = isDarkMode ? Colors.white : Colors.black;
Color borderColor = isDarkMode ? Colors.white : Colors.black;
  return Container(
    color: backgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection('Micros', [
            _buildTableRow('Primaria', '0.60 Bs', textColor),
            _buildTableRow('Secundaria', '0.80 Bs', textColor),
              _buildTableRow('Universitarios', '1.00 Bs', textColor),
              _buildTableRow('Adulto Mayor', '1.50 Bs', textColor),
              _buildTableRow('Horarios', '', textColor),
              _buildTableRow('Lunes - Domingo', '07:00 am - 21:00 pm', textColor),
            
          ], backgroundColor, textColor,borderColor),
          SizedBox(height: 16.0), 
            _buildSection('Taxitrufis', [
              _buildTableRow('Todos', '2.00 Bs', textColor),
              _buildTableRow('Horarios', '', textColor),
              _buildTableRow('Lunes - Domingo', '07:00 am - 21:00 pm', textColor),
             
            ], backgroundColor, textColor, borderColor),
        ],
      ),
    ),
  );
}


 Widget _buildSection(String title, List<Widget> rows, Color backgroundColor, Color textColor, Color borderColor) {
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: backgroundColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
        ),
        SizedBox(height: 8.0),
        _buildTableHeader(textColor),
        ...rows,
      ],
    ),
  );
}

Widget _buildTableHeader(Color textColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildTableCell('Tipo', textColor: textColor),
      _buildTableCell('Tarifa', textColor: textColor),
    ],
  );
}


  Widget _buildTableRow(String ruta, String tarifa, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTableCell(ruta, textColor: textColor),
        _buildTableCell(tarifa, textColor: textColor),
      ],
    );
  }

Widget _buildTableCell(String text, {Color? textColor}) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 16.0, color: textColor),
    ),
  );
}


}
