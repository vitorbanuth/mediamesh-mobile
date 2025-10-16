class Task {
  final String unique;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String assignee;
  final String status;

  Task({
    required this.unique,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.assignee,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    String formatDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return "";
      try {
        final parsedDate = DateTime.parse(rawDate); // converte a string ISO
        return "${parsedDate.day.toString().padLeft(2, '0')}/"
            "${parsedDate.month.toString().padLeft(2, '0')}/"
            "${parsedDate.year}";
      } catch (e) {
        return rawDate;
      }
    }

    String formatStatus(String? rawStatus) {
      if (rawStatus == null || rawStatus.isEmpty) return "";

      if (rawStatus == "NEW") {
        rawStatus = "Novo";
      }
      else if (rawStatus == "INPROGRESS") {
        rawStatus = "Em Progresso";
      }
      else if (rawStatus == "DONE") {
        rawStatus = "Finalizada";
      }
      return rawStatus;
    }

    return Task(
      unique: json["unique"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      startDate: formatDate(json["startDate"] ?? ""),
      endDate: formatDate(json["endDate"] ?? ""),
      assignee: json["assignee"] ?? "",
      status: formatStatus(json["status"] ?? ""),
    );
  }
}
