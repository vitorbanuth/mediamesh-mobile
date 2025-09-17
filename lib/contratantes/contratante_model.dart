class Contratante {
  final String taxId;
  final String name;
  final String sector;
  final String address;
  final String cep;
  final Contact contact;

  Contratante({
    required this.taxId,
    required this.name,
    required this.sector,
    required this.address,
    required this.cep,
    required this.contact,
  });

  factory Contratante.fromJson(Map<String, dynamic> json) {
    return Contratante(
      taxId: json["taxId"] ?? "",
      name: json["name"] ?? "",
      sector: json["sector"] ?? "",
      address: json["address"] ?? "",
      cep: json["cep"] ?? "",
      contact: Contact.fromJson(json["contact"] ?? {}),
    );
  }
}

class Contact {
  final String name;
  final String email;
  final String phone;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}