import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira_report.dart';
import 'package:projeto_flutter_21805677/Models/report.dart';
import 'package:projeto_flutter_21805677/data/cm_database.dart';
import 'package:provider/provider.dart';
import 'package:projeto_flutter_21805677/Models/combined_reports.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<CombinedReport>> _combinedReportsFuture;

  @override
  void initState() {
    super.initState();
    _combinedReportsFuture = getCombinedReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Dashboard'),
      ),
      body: FutureBuilder<List<CombinedReport>>(
        future: _combinedReportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reports found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var report = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: cardTitle(report),
                    subtitle: Text('Date: ${report.dateInfo}'),
                    trailing: Text('Local: ${report.locationId}'
                        '\nObservações: ${report.obs}'
                        ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget cardTitle(CombinedReport report){
    if(report.severity != null){
      return Text('Park Report ID: ${report.reportId}');
    }else {
      return Text('GIRA Report ID: ${report.reportId}');
    }
  }

  Future<List<CombinedReport>> getParkReports() async {
    final repository = context.read<CmDatabase>();
    final List<Report> parkReports = await repository.getParkReports();

    return parkReports.map((report) {
      return CombinedReport(
        reportId: report.reportId,
        locationId: report.parkId ?? '',
        severity: report.severity,
        type: null,
        obs: report.obs ?? '',
        dateInfo: report.dateInfo ?? '',
      );
    }).toList();
  }

  Future<List<CombinedReport>> getGiraReports() async {
    final repository = context.read<CmDatabase>();
    final List<GiraReport> giraReports = await repository.getGiraReports();

    return giraReports.map((report) {
      return CombinedReport(
        reportId: report.reportId,
        locationId: report.giraId ?? '',
        severity: null,
        type: report.type,
        obs: report.obs,
        dateInfo: report.dateInfo ?? '',
      );
    }).toList();
  }

  Future<List<CombinedReport>> getCombinedReports() async {
    final parkReports = await getParkReports();
    final giraReports = await getGiraReports();

    List<CombinedReport> combinedList = [];
    combinedList.addAll(parkReports);
    combinedList.addAll(giraReports);

    combinedList.sort((a, b) {
      DateTime dateA = DateTime.parse(a.dateInfo);
      DateTime dateB = DateTime.parse(b.dateInfo);
      return dateB.compareTo(dateA); // sort by descending date
    });

    return combinedList;
  }
}


/*
import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/pages/pages.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[0].title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello')
          ],
        ),
      ),
    );
  }
}
*/

