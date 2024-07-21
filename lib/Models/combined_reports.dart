class CombinedReport {
  final String reportId;
  final String locationId; // This can be either parkId or giraId
  final int? severity; // Nullable for GiraReport
  final int? type; // Nullable for Report
  final String obs;
  final String dateInfo;

  CombinedReport({
    required this.reportId,
    required this.locationId,
    this.severity,
    this.type,
    required this.obs,
    required this.dateInfo,
  });
}
