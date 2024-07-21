import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/pages/gira_detail.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class Giras extends StatefulWidget {
  const Giras({super.key});

  @override
  State<Giras> createState() => _GirasState();
}

class _GirasState extends State<Giras> {

  bool _loadList = true;
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
          'GIRA',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loadList
            ? buildFutureGiraList(repository)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildFutureGiraList(ParksRepository repository) {
    return FutureBuilder(
      future: repository.getGiras(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return buildParkList(snapshot.data ?? []);
        }
      },
    );
  }

  Widget buildParkList(List<Gira> giras) {
    return ListView.separated(
      itemBuilder: (_, index) => ListTile(
        title: Text(giras[index].address),
        subtitle: Text(
          'Número de bicicletas: ${giras[index].numOfBikes} - último update: ${giras[index].lastUpdate}',
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiraDetail(
              giraId: giras[index].giraId,
              source: _source!,
            ),
          ),
        ),
      ),
      separatorBuilder: (_, index) => Divider(color: Colors.grey, thickness: 0.5),
      itemCount: giras.length,
    );
  }
}