class Report {

  String reportId;
  String? parkId;
  int? severity;
  String? dateInfo;
  String? obs;


  Report({required this.reportId,required this.parkId,required this.severity, required this.dateInfo, required this.obs});

  factory Report.fromDB(Map<String, dynamic> db){
    return Report(
      reportId: db['report_id'] ?? 'nullReport',
      parkId: db['park_id'] ?? 'nullReport',
      severity: db['severity'] ?? 'nullReport',
      dateInfo: db['date_info'].toString(),
      obs: db['obs'] ?? 'nullReport',
    );
  }

  Map<String, dynamic> toDb(){
    return {
      'report_id': reportId,
      'park_id': parkId,
      'severity': severity,
      'date_info': dateInfo,
      'obs': obs,
    };
  }

}