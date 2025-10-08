class Home {
  final Status campaignStatus;
  final StorageUsage homeUsage;

  Home({
    required this.campaignStatus,
    required this.homeUsage,
  });

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      campaignStatus: Status.fromJson(json["totalByStatus"] ?? {}),
      homeUsage: StorageUsage.fromJson(json["storageUsageTotal"] ?? {})
    );
  }
}

class Status {
  final int invoiced;
  final int published;
  final int done;
  final int newStatus;

  Status({
    required this.invoiced,
    required this.published,
    required this.done,
    required this.newStatus,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      invoiced: json["INVOICED"] ?? "",
      published: json["PUBLISHED"] ?? "",
      done: json["DONE"] ?? "",
      newStatus: json["NEW"] ?? ""
    );
  }
}

class StorageUsage {
  final int artsTotal;
  final int artsUsage;
  final int snapsTotal;
  final int snapsUsage;
  final int docsTotal;
  final int docsUsage;

  StorageUsage({
    required this.artsTotal,
    required this.artsUsage,
    required this.snapsTotal,
    required this.snapsUsage,
    required this.docsTotal,
    required this.docsUsage,
  });

  factory StorageUsage.fromJson(Map<String, dynamic> json) {
    return StorageUsage(
      artsTotal: json["artsTotal"] ?? "",
      artsUsage: json["artsUsage"] ?? "",
      snapsTotal: json["snapsTotal"] ?? "",
      snapsUsage: json["snapsUsage"] ?? "",
      docsTotal: json["docsTotal"] ?? "",
      docsUsage: json["docsUsage"] ?? "",
    );
  }
}