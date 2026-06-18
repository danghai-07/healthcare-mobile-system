class Specialty {
  const Specialty({
    this.id,
    this.name,
    this.description,
    this.isDeleted = false,
  });

  final int? id;
  final String? name;
  final String? description;
  final bool isDeleted;
}
