class Campanha {
  final String unique;
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
  final List<CampanhaPonto> campanhaPonto;

  Campanha({
    required this.unique,
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
    required this.campanhaPonto,
  });

  factory Campanha.fromJson(Map<String, dynamic> json) {
    String formatStatus(String? rawStatus) {
      if (rawStatus == null || rawStatus.isEmpty) return "";

      if (rawStatus == "NEW") {
        rawStatus = "Novo";
      } else if (rawStatus == "PUBLISHED") {
        rawStatus = "Publicada";
      } else if (rawStatus == "DONE") {
        rawStatus = "Finalizada";
      } else if (rawStatus == "INVOICED") {
        rawStatus = "Faturada";
      }
      return rawStatus;
    }

    return Campanha(
      unique: json["unique"] ?? "",
      pi: json["pi"] ?? "",
      status: formatStatus(json["status"] ?? ""),
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
      campanhaPonto:
          (json["pops"] as List<dynamic>?)
              ?.map((p) => CampanhaPonto.fromJson(p))
              .toList() ??
          [],
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

class CampanhaPonto {
  final String id;
  final String unique;
  final String vehicle;
  final String account;
  final String address;
  final Dimensions dimensions;
  final String endTime;
  final String faceDescription;
  final String facePosition;
  final bool hasCapacity;
  final bool is3D;
  final String kind;
  final Location location;
  final String material;
  final String name;
  final String orientation;
  final Presentation presentation;
  final String reference;
  final int slotInsertsDay;
  final int slotLoopTotalMin;
  final int slotTimeSecs;
  final int slots;
  final String startTime;
  final int totalInsertsDay;
  final List<Periods> periods;

  CampanhaPonto({
    required this.id,
    required this.unique,
    required this.vehicle,
    required this.account,
    required this.address,
    required this.dimensions,
    required this.endTime,
    required this.faceDescription,
    required this.facePosition,
    required this.hasCapacity,
    required this.is3D,
    required this.kind,
    required this.location,
    required this.material,
    required this.name,
    required this.orientation,
    required this.presentation,
    required this.reference,
    required this.slotInsertsDay,
    required this.slotLoopTotalMin,
    required this.slotTimeSecs,
    required this.slots,
    required this.startTime,
    required this.totalInsertsDay,
    required this.periods,
  });

  factory CampanhaPonto.fromJson(Map<String, dynamic> json) {
    return CampanhaPonto(
      id: json["_id"] ?? "",
      unique: json["unique"] ?? "",
      vehicle: json["vehicle"] ?? "",
      account: json["account"] ?? "",
      address: json["address"] ?? "",
      dimensions: Dimensions.fromJson(json["dimensions"] ?? {}),
      endTime: json["endTime"] ?? "",
      faceDescription: json["faceDescription"] ?? "",
      facePosition: json["facePosition"] ?? "",
      hasCapacity: json["hasCapacity"] ?? false,
      is3D: json["is3D"] ?? false,
      kind: json["kind"] ?? "",
      location: Location.fromJson(json["location"] ?? {}),
      material: json["material"] ?? "",
      name: json["name"] ?? "",
      orientation: json["orientation"] ?? "",
      presentation: Presentation.fromJson(json["presentation"] ?? {}),
      reference: json["reference"] ?? "",
      slotInsertsDay: json["slotInsertsDay"] ?? 0,
      slotLoopTotalMin: json["slotLoopTotalMin"] ?? 0,
      slotTimeSecs: json["slotTimeSecs"] ?? 0,
      slots: json["slots"] ?? 0,
      startTime: json["startTime"] ?? "",
      totalInsertsDay: json["totalInsertsDay"] ?? 0,
      periods:
          (json["periods"] as List<dynamic>?)
              ?.map((p) => Periods.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class Periods {
  final String unique;
  final String startDate;
  final String endDate;
  final bool isBonus;
  final int insertsDay;
  final int insertsPeriod;
  final int totalDays;
  final int occupationDay;
  final String hash;

  Periods({
    required this.unique,
    required this.startDate,
    required this.endDate,
    required this.isBonus,
    required this.insertsDay,
    required this.insertsPeriod,
    required this.totalDays,
    required this.occupationDay,
    required this.hash,
  });

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      unique: json["unique"] ?? "",
      startDate: formatDate(json["startDate"] ?? ""),
      endDate: formatDate(json["endDate"] ?? ""),
      isBonus: json["isBonus"] ?? false,
      insertsDay: json["insertsDay"] ?? 0,
      insertsPeriod: json["insertsPeriod"] ?? 0,
      totalDays: json["totalDays"] ?? 0,
      occupationDay: json["occupationDay"] ?? 0,
      hash: json["hash"] ?? "",
    );
  }
}

class Dimensions {
  final int artWidth;
  final int artHeight;
  final int width;
  final int height;
  final String unit;

  Dimensions({
    required this.artWidth,
    required this.artHeight,
    required this.width,
    required this.height,
    required this.unit,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      artWidth: json["artWidth"] ?? 0,
      artHeight: json["artHeight"] ?? 0,
      width: json["width"] ?? 0,
      height: json["height"] ?? 0,
      unit: json["unit"] ?? "",
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"] ?? "",
      coordinates:
          (json["coordinates"] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}

class ImageData {
  final String unique;

  ImageData({required this.unique});

  factory ImageData.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ImageData(unique: json["unique"] ?? "");
    } else if (json is String) {
      return ImageData(unique: json);
    } else {
      return ImageData(unique: "");
    }
  }
}

class Presentation {
  final String description;
  final ImageData image;

  Presentation({required this.description, required this.image});

  factory Presentation.fromJson(Map<String, dynamic> json) {
    return Presentation(
      description: json["description"] ?? "",
      image: ImageData.fromJson(json["image"] ?? {}),
    );
  }
}

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
