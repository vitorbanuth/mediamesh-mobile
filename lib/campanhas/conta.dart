class Conta {
  final String unique;
  final String taxId;
  final String name;
  final String slug;
  final String alias;
  final String email;
  final String phone;
  final bool isPrimary;
  final Logo logo;

  Conta({
    required this.unique,
    required this.taxId,
    required this.name,
    required this.slug,
    required this.alias,
    required this.email,
    required this.phone,
    required this.isPrimary,
    required this.logo,
  });

  factory Conta.fromJson(Map<String, dynamic> json) {
    return Conta(
      unique: json["unique"] ?? "",
      taxId: json["taxId"] ?? "",
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      alias: json["alias"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      logo: Logo.fromJson(json["logo"] ?? {}),
    );
  }
}

class Logo {
  final int size;
  final String name;
  final String hash;

  Logo({required this.size, required this.name, required this.hash});

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      size: json["size"] ?? 0,
      name: json["name"] ?? "",
      hash: json["hash"] ?? "",
    );
  }
}
