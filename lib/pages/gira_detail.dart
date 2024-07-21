import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira.dart';
import 'package:projeto_flutter_21805677/Models/gira_report.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class GiraDetail extends StatefulWidget {
  const GiraDetail({super.key, required this.giraId, required this.source});

  final String giraId;
  final String source;

  @override
  State<GiraDetail> createState() => _GiraDetailState();
}

class _GiraDetailState extends State<GiraDetail> {

  Gira? _gira;

  @override
  void initState() {
    super.initState();

    final repository = context.read<ParksRepository>();
    final futureGira = repository.getGira(widget.giraId);

    futureGira.then((gira) {
      setState(() {
        _gira = gira;
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
            buildFutureGiraDetail(repository, database, context),
            SizedBox(height: 20),
            Text(
              'Lista de Incidentes Gira',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildFutureReportList(database),
          ],
        ),
      ),
    );
  }

  Widget buildGira(Gira gira) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          width: 150,
          image: NetworkImage(
            'https://img.acp.pt/ResourcesUser/ImagesAC/Atualidade/2023/Mes11/Estacionamento-/Parque-Pontinha.jpg', //TODO: MUDAR IMAGEM
          ),
        ),
        SizedBox(height: 10),
        Text(gira.giraId, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Morada: ${gira.address}', style: TextStyle(fontSize: 16)),
        Text('Numero de docas: ${gira.numOfDocks}', style: TextStyle(fontSize: 16)),
        Text('Número de bicicletas: ${gira.numOfBikes}', style: TextStyle(fontSize: 16)),
        Text('Data de ultima atualização: ${gira.lastUpdate}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  FutureBuilder<Gira?> buildFutureGiraDetail(ParksRepository repository, CmDatabase database, context) {
    return FutureBuilder(
      future: widget.source == 'network' ? repository.getGira(widget.giraId) : database.getGira(widget.giraId),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            print('SNAPSHOTDATA: ${snapshot.data}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Gira list = snapshot.data!; //TODO
            return buildGira(list);
          }
        }
      },
    );
  }

  FutureBuilder<List<GiraReport>> buildFutureReportList(CmDatabase database) {
    return FutureBuilder(
      future: database.getGiraReports(widget.giraId),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return buildReportsList(snapshot.data ?? []);
        }
      },
    );
  }

  Widget buildReportsList(List<GiraReport> reports) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => ListTile(
        leading: Icon(Icons.report),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estação: ${reports[index].giraId}', style: TextStyle(fontSize: 18)),
            Text('Tipo de problema ${reports[index].type}', style: TextStyle(fontSize: 12)), //TODO: convert type to text MAYBE
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
