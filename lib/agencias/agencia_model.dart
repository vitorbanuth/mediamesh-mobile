class Agencia {
  final String taxId;
  final String name;
  final Contact contact;

  Agencia({
    required this.taxId,
    required this.name,
    required this.contact,
  });

  factory Agencia.fromJson(Map<String, dynamic> json) {
    return Agencia(
      taxId: json["taxId"] ?? "",
      name: json["name"] ?? "",
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
