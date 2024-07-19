import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/Park.dart';
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
      appBar: AppBar(title: Text(_park!.name),),
      body: Center(
        child: FutureBuilder(
          future: repository.getPark(_park!.parkId),
          builder: (_,snapshot) {

            if (snapshot.connectionState != ConnectionState.done){
              return CircularProgressIndicator();
            } else if (snapshot.hasError){
              return Text('Erro');
            } else
              return buildPark(snapshot.data as Park);
        },
        ),
      ));
      
  }

  Widget buildPark(Park park) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_park!.name, style: TextStyle(fontSize: 40),),
              Text('POR ALGO')
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
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return buildPark(snapshot.data!);
          }
        }
      },
    );
  }
}
