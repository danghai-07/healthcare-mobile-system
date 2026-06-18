import '../../../../core/utils/json_read.dart';

/// Swagger: Service entity (response)
class ServiceDto {
  const ServiceDto({
    required this.serviceId,
    this.name,
    this.description,
    this.price,
  });

  final int serviceId;
  final String? name;
  final String? description;
  final double? price;

  factory ServiceDto.fromJson(Map<String, dynamic> json) => ServiceDto(
        serviceId: JsonRead.intValue(json, 'serviceId') ?? 0,
        name: JsonRead.string(json, 'name'),
        description: JsonRead.string(json, 'description'),
        price: JsonRead.doubleValue(json, 'price'),
      );
}

/// Swagger: CreateServiceDTO
class CreateServiceDto {
  const CreateServiceDto({
    required this.name,
    required this.description,
    this.price,
  });

  final String name;
  final String description;
  final double? price;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
      };
}
