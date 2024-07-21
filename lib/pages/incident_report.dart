import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira_listing.dart';
import 'package:projeto_flutter_21805677/Models/gira_report.dart';
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
  GiraListing? selectedGira;

  String parkId = 'null';
  String giraId = 'null';

  var severityLevels = ['1', '2', '3', '4', '5'];
  String? selectedSeverityLevel;
  String severity = 'null';

  String? selectedType;
  var types = ['Bicicleta vandalizada', 'Doca não libertou bicicleta', 'Outra situação'];
  String type = 'null';

  TextEditingController obsController = TextEditingController();
  String obs = 'null';

  final formKey = GlobalKey<FormState>();
  final giraFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final repository = context.read<ParksRepository>();
    final database = context.read<CmDatabase>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registar Incidente",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            labelColor: Colors.white, // Set the color for selected tab text
            unselectedLabelColor: Colors.white54, // Set the color for unselected tab text
            labelStyle: TextStyle(color: Colors.white), // Ensure selected text is white
            unselectedLabelStyle: TextStyle(color: Colors.white54), // Ensure unselected text is slightly less white
            tabs: [
              Tab(text: 'Parque'),
              Tab(text: 'Gira'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: repository.parkListing(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return buildParkForm(database, snapshot.data ?? []);
                }
              },
            ),
            FutureBuilder(
              future: repository.giraListing(), // Assuming you have a similar method for Gira listings
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return buildGiraForm(database, snapshot.data ?? []);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildParkForm(CmDatabase database, List<ParkListing> parks) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
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

  Widget buildGiraForm(CmDatabase database, List<GiraListing> giras) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: giraFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGiraList(giras),
            SizedBox(height: 10),
            buildTypeDropdown(),
            SizedBox(height: 10),
            buildGiraObsForm(),
            SizedBox(height: 10),
            buildSubmitButton(database),
          ],
        ),
      ),
    );
  }

  Widget buildGiraList(List<GiraListing> giras) {
    return DropdownButtonFormField<GiraListing>(
      value: selectedGira,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Estação do incidente...',
      ),
      onChanged: (GiraListing? value) {
        setState(() {
          selectedGira = value;
          giraId = value?.giraId ?? '';
        });
      },
      items: giras.map((GiraListing item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.address),
        );
      }).toList(),
    );
  }

  Widget buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Tipo de incidente...',
      ),
      items: types.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedType = value;
          type = value ?? '';
        });
      },
    );
  }

  Widget buildGiraObsForm() {
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

        if(severity == 'null' || parkId == 'null' || obs == 'null'){

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Todos os campos são obrigatórios'),
          ));

        } else{

          database.insertReport(Report(
            reportId: '',
            parkId: parkId,
            severity: int.parse(severity),
            dateInfo: DateTime.now().toString(),
            obs: obs,
          ));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incidente reportado!'),
          ));
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text('Submeter'),
    );
  }

  Widget buildGiraSubmitButton(CmDatabase database) {
    return ElevatedButton(
      onPressed: ()  {

        if(type == 'null' || giraId == 'null' || obs == 'null'){

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Todos os campos são obrigatórios'),
          ));

        } else if (obs.length < 20) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Minimo 20 caracteres nas observações'),
          ));

        } else {

          int typeInt = 0;

          switch(type){
            case 'Bicicleta vandalizada':
              typeInt = 1;
              break;
            case 'Doca não libertou bicicleta':
              typeInt = 2;
              break;
            case 'Outra situação':
              typeInt = 3;
              break;
          }

            database.insertGiraReport(GiraReport(
              reportId: '',
              giraId: giraId,
              type: typeInt,
              obs: obs,
              dateInfo: DateTime.now().toString(),
            ));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Incidente reportado!'),
            ));
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
