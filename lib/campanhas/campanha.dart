class Campanha {
  final String pi;
  final String status;
  final String name;
  final String startDate;
  final String endDate;
  final String address;
  final String region;
  final String product;
  final String format;
  final bool isAudited;
  final CampanhaContratante campanhaContratante;

  Campanha({
    required this.pi,
    required this.status,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.region,
    required this.product,
    required this.format,
    required this.isAudited,
    required this.campanhaContratante,
  });

  factory Campanha.fromJson(Map<String, dynamic> json) {
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

    return Campanha(
      pi: json["pi"] ?? "",
      status: json["status"] ?? "",
      name: json["name"] ?? "",
      startDate: formatDate(json["startDate"] ?? ""),
      endDate: formatDate(json["endDate"] ?? ""),
      address: json["address"] ?? "",
      region: json["region"] ?? "",
      product: json["product"] ?? "",
      format: json["format"] ?? "",
      isAudited: json["isAudited"] ?? "",
      campanhaContratante: CampanhaContratante.fromJson(
        json["advertiser"] ?? {},
      ),
    );
  }
}

class CampanhaContratante {
  final String taxId;
  final String name;

  CampanhaContratante({required this.taxId, required this.name});

  factory CampanhaContratante.fromJson(Map<String, dynamic> json) {
    return CampanhaContratante(
      name: json["name"] ?? "",
      taxId: json["taxId"] ?? "",
    );
  }
}
