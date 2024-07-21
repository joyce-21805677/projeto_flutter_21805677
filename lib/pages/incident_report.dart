import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/report.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({super.key});

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {

  ParkListing? selected;
  var severityLevels = ['1', '2', '3', '4', '5'];
  String? selectedSeverityLevel;
  TextEditingController obsController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late String parkId;
  late String severity;
  late String obs;


  @override
  Widget build(BuildContext context) {

    final repository = context.read<ParksRepository>();
    final database = context.read<CmDatabase>();


    return Scaffold(
      appBar: AppBar(
        title: Text( "Registar Incidente",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: repository.parkListing(),
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

  Widget buildForm(CmDatabase database, List<ParkListing> parks) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildParkList(parks),
          SizedBox(height: 10),
          buildSeverityDropdown(),
          SizedBox(height: 10),
          buildObsForm(),
          SizedBox(height: 10),
          buildSubmitButton(database),
        ],
      ),
    );
  }

  Widget buildParkList(List<ParkListing> parks) {
    return DropdownButtonFormField<ParkListing>(
      value: selected,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Local do incidente...',
      ),
      onChanged: (ParkListing? value) {
        setState(() {
          selected = value;
          parkId = value?.parkId ?? '';
        });
      },
      items: parks.map((ParkListing item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.name),
        );
      }).toList(),
    );
  }

  Widget buildSeverityDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedSeverityLevel,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Gravidade do incidente...',
      ),
      items: severityLevels.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedSeverityLevel = value;
          severity = value ?? '';
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
        print(parkId);
        print(severity);
        print(obsController.text);

        if(severity == 'default_debug_report_gravidade' || parkId == 'default_debug_report_id_parque' || obs == 'default_debug_report_notas'){

          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            content: Text('Todos os campos são obrigatórios'),
          )));

        } else{

          database.insertReport(Report(reportId: '', parkId: parkId, severity: int.parse(severity), dateInfo: DateTime.now().toString(), obs: obs));

          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            content: Text('Incidente reportado!'),
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
