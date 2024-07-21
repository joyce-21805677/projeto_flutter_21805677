class GiraReport {

  String reportId;
  String? giraId;
  String obs;
  int type;


  GiraReport({required this.reportId,required this.giraId,required this.obs, required this.type});

  factory GiraReport.fromDB(Map<String, dynamic> db){
    return GiraReport(
      reportId: db['report_id'] ?? 'nullReport',
      giraId: db['gira_id'] ?? 'nullReport',
      obs: db['obs'] ?? 'nullReport',
      type: db['type'],
    );
  }

  Map<String, dynamic> toDb(){
    return {
      'report_id': reportId,
      'gira_id': giraId,
      'obs': obs,
      'type': type,
    };
  }

}