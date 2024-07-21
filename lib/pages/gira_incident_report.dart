import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira_listing.dart';
import 'package:projeto_flutter_21805677/Models/gira_report.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/report.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class GiraIncidentReport extends StatefulWidget {
  const GiraIncidentReport({super.key});

  @override
  State<GiraIncidentReport> createState() => _GiraIncidentReportState();
}

class _GiraIncidentReportState extends State<GiraIncidentReport> {

  GiraListing? selected;
  var possibleTypes = ['Bicicleta vandalizada', 'Doca não libertou bicicleta', 'Outra situação'];
  String? selectedType;
  TextEditingController obsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String giraId = 'null';
  int type = 0;
  String selectedTypeString = 'null';
  String obs = 'null';


  @override
  Widget build(BuildContext context) {

    final repository = context.read<ParksRepository>();
    final database = context.read<CmDatabase>();


    return Scaffold(
      appBar: AppBar(
        title: Text( "Registar Incidente Gira",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: repository.giraListing(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return buildForm(database, snapshot.data ?? []);
            }
          },
        ),
      ),
    );
  }

  Widget buildForm(CmDatabase database, List<GiraListing> giras) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildGiraList(giras),
          SizedBox(height: 10),
          buildTypeDropdown(),
          SizedBox(height: 10),
          buildObsForm(),
          SizedBox(height: 10),
          buildSubmitButton(database),
        ],
      ),
    );
  }

  Widget buildGiraList(List<GiraListing> giras) {
    return DropdownButtonFormField<GiraListing>(
      value: selected,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Local do incidente...',
      ),
      onChanged: (GiraListing? value) {
        setState(() {
          selected = value;
          giraId = value?.giraId ?? '';
        });
      },
      items: giras.map((GiraListing item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.giraId),
        );
      }).toList(),
    );
  }

  Widget buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Gravidade do incidente...',
      ),
      items: possibleTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedType = value;
          switch(value){
            case 'Bicicleta vandalizada':
              type = 1;
              break;
            case 'Doca não libertou bicicleta':
              type = 2;
              break;
            case 'Outra situação':
              type = 3;
              break;
          }
        });
      },
    );
  }

  Widget buildObsForm() {
    return TextFormField(
      controller: obsController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Observações',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        obs = value;
      },
    );
  }

  Widget buildSubmitButton(CmDatabase database) {
    return ElevatedButton(
      onPressed: ()  {
        obs = obsController.text.toString();
        print(giraId);
        print(type);
        print(obsController.text);

        if(giraId == 'null'|| obs == 'null' || type == 0){

          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            content: Text('Todos os campos são obrigatórios'),
          )));

        } else{

          switch(selectedType){
            case 'Bicicleta vandalizada':
              type = 1;
              break;
            case 'Doca não libertou bicicleta':
              type = 2;
              break;
            case 'Outra situação':
              type = 3;
              break;

          }

          database.insertGiraReport(GiraReport(reportId: '', giraId: giraId, obs: obs, type: type));

          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            content: Text('Incidente gira reportado!'),
          )));
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text('Submeter'),
    );
  }
}
