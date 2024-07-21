import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/pages/park_detail.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class Parks extends StatefulWidget {
  const Parks({super.key});

  @override
  State<Parks> createState() => _ParksState();
}

class _ParksState extends State<Parks> {

  bool _loadList = true;
  //List<Park> _parks = [];

  String? _source;

  @override
  void initState() {
    super.initState();
    _source = 'network';
  }

  @override
  Widget build(BuildContext context) {

    final repository = context.read<ParksRepository>();
    final database = context.read<CmDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parques',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loadList
            ? buildFutureParkList(repository)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildFutureParkList(ParksRepository repository) {
    return FutureBuilder(
      future: repository.getParks(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        } else {
          return buildParkList(snapshot.data ?? []);
        }
      },
    );
  }

  Widget buildParkList(List<Park> parks) {
    return ListView.separated(
      itemBuilder: (_, index) => ListTile(
        title: Text(parks[index].name),
        subtitle: Text(
          'Ocupação: ${parks[index].ocupation < 0 ? parks[index].ocupation * -1 : parks[index].ocupation }/${parks[index].maxCapacity} - Tipo: ${parks[index].type}',
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParkDetail(
              parkId: parks[index].parkId,
              source: _source!,
            ),
          ),
        ),
      ),
      separatorBuilder: (_, index) => Divider(color: Colors.grey, thickness: 0.5),
      itemCount: parks.length,
    );
  }
}