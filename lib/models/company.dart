class Company {
  final String name;
  final String tin;
  final String logoUrl;

  Company({
    required this.name,
    required this.tin,
    required this.logoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tin': tin,
      'logoUrl': logoUrl,
    };
  }
}
