import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reciward_flutter_app/core/constants/pallete_colors.dart';
import 'package:reciward_flutter_app/core/widgets/app_bar_reciward.dart';
import 'package:reciward_flutter_app/core/widgets/nav_reciward.dart';
import 'package:reciward_flutter_app/features/aprendiz/bono/domain/entities/get_historial_bono.dart';
import 'package:reciward_flutter_app/features/aprendiz/bono/presentation/bloc/bono_bloc.dart';
import 'package:reciward_flutter_app/features/aprendiz/puntos/presentation/widgets/get_puntos_banner.dart';

class HomeBonoPage extends StatefulWidget {
  const HomeBonoPage({Key? key}) : super(key: key);

  @override
  _HomeBonoPageState createState() => _HomeBonoPageState();
}

class _HomeBonoPageState extends State<HomeBonoPage> {
  bool _showTable = false;
  List<List<String>> _tableData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.colorWhite,
      appBar: const AppBarReciward(),
      body: Column(
        children: [
          const GetPuntosBanner(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showTable = !_showTable;
              });
            },
            child: Text(_showTable
                ? '  Ocultar historial de bonos  '
                : '  Mostrar historial de bonos  '),
          ),
          const SizedBox(height: 10),
          if (_showTable) ...[
            const Text(
              'Historial',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 360,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 84, 104, 59)),
                color: const Color.fromARGB(255, 221, 221, 220),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocBuilder<BonoBloc, BonoState>(
                builder: (context, state) {
                  if (state is GetHistorialBonosSuccess) {
                    final bonos = state.bonos;
                    return Table(
                      border: TableBorder.all(color: Colors.transparent),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                      },
                      defaultColumnWidth: const FixedColumnWidth(100),
                      children: _buildTableRows(bonos),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: const NavReciward(
        currentIndex: 2,
      ),
    );
  }

  List<TableRow> _buildTableRows(List<GetHistorialBono> bonos) {
    return [
      const TableRow(
        children: [
          TableCell(
              child: Center(child: Text('Id', style: TextStyle(fontSize: 16)))),
          TableCell(
              child: Center(
                  child: Text('Codigo', style: TextStyle(fontSize: 16)))),
          TableCell(
              child: Center(
                  child: Text('Estado', style: TextStyle(fontSize: 16)))),
          TableCell(
              child: Center(
                  child: Text('Tiempo', style: TextStyle(fontSize: 16)))),
        ],
      ),
      for (GetHistorialBono bono in bonos) ...[
        TableRow(
          children: [
            TableCell(
              child: Center(
                child: Text(
                  bono.id!,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  bono.codigoValidante!,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Text(
                  bono.estadoBono! ? "Activo" : "Inactivo",
                  style: TextStyle(
                      fontSize: 14,
                      color: bono.estadoBono! ? Colors.green : Colors.red),
                ),
              ),
            ),
            TableCell(
              child: StreamBuilder<Duration>(
                stream: bono.isActive
                    ? Stream.periodic(const Duration(seconds: 1), (count) {
                        bono.calculateRemainingTime();
                        return bono.remainingTime;
                      })
                    : null, // Detener el stream si el bono no está activo
                builder: (context, snapshot) {
                  if (!bono.isActive) {
                    return Center(
                        child: Text(
                      'Bono inactivo',
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return Center(
                    child: Text(
                      '${bono.remainingTime.inDays}D${bono.remainingTime.inHours.remainder(24)}H${bono.remainingTime.inMinutes.remainder(60)}M${bono.remainingTime.inSeconds.remainder(60)}S',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ];
  }

  // Función para actualizar los datos de la tabla
  void updateTableData(List<List<String>> newData) {
    setState(() {
      _tableData = newData;
    });
  }
}
