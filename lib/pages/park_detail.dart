import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/Models/report.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class ParkDetailpage extends StatefulWidget {
  const ParkDetailpage({super.key, required this.parkId, required this.source});

  final String parkId;
  final String source;

  @override
  State<ParkDetailpage> createState() => _ParkDetailpageState();
}

class _ParkDetailpageState extends State<ParkDetailpage> {

  Park? _park;

  @override
  void initState() {
    super.initState();

    final repository = context.read<ParksRepository>();
    final futurePark = repository.getPark(widget.parkId);

    futurePark.then((park) {
      setState(() {
        _park = park as Park?;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final repository = context.read<ParksRepository>();
    final database = context.read<CmDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes',
          style: TextStyle(
            fontSize: 20, // Adjust font size as needed
            fontWeight: FontWeight.bold, // Optionally, make the title bold
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFutureParkDetail(repository, database, context),
            SizedBox(height: 20),
            Text(
              'Lista de Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildFutureReportList(database),
          ],
        ),
      ),
    );
  }

  Widget buildPark(Park park) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 150,
          image: NetworkImage(
            'https://img.acp.pt/ResourcesUser/ImagesAC/Atualidade/2023/Mes11/Estacionamento-/Parque-Pontinha.jpg',
          ),
        ),
        SizedBox(height: 10),
        Text(park.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Data de ultima atualização: ${park.ocupationDate}', style: TextStyle(fontSize: 16)),
        Text('Ocupação: ${park.ocupation < 0 ? park.ocupation * -1 : park.ocupation }', style: TextStyle(fontSize: 16)),
        Text('Lugares disponivéis: ${ park.ocupation < 0 ? park.maxCapacity + park.ocupation: park.maxCapacity - park.ocupation}', style: TextStyle(fontSize: 16)),
        Text('Tipo de parque: ${park.type}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  FutureBuilder<Park?> buildFutureParkDetail(ParksRepository repository, CmDatabase database, context) {
    return FutureBuilder(
      future: widget.source == 'network' ? repository.getPark(widget.parkId) : database.getPark(widget.parkId),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildPark(snapshot.data!);
          }
        }
      },
    );
  }

  FutureBuilder<List<Report>> buildFutureReportList(CmDatabase database) {
    return FutureBuilder(
      future: database.getParkReports(widget.parkId),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else {
          return buildReportsList(snapshot.data ?? []);
        }
      },
    );
  }

  Widget buildReportsList(List<Report> reports) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => ListTile(
        leading: Icon(Icons.report),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gravidade: ${reports[index].severity}', style: TextStyle(fontSize: 18)),
            Text('Reportado a ${reports[index].dateInfo}', style: TextStyle(fontSize: 12)),
            Text('Observações:\n${reports[index].obs}', style: TextStyle(fontSize: 14)
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
      ),
      separatorBuilder: (_, index) => Divider(color: Colors.grey, thickness: 0.5),
      itemCount: reports.length,
    );
  }


}
