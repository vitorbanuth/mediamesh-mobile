class Ponto {
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

  Ponto({
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
  });

  factory Ponto.fromJson(Map<String, dynamic> json) {
    return Ponto(
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
    );
  }

  void addPonto() {
    
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
