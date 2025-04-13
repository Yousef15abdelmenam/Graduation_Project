import 'package:equatable/equatable.dart';

class Address extends Equatable {
	final String? streetAddress;
	final String? city;
	final int? latitude;
	final int? longitude;

	const Address({
		this.streetAddress, 
		this.city, 
		this.latitude, 
		this.longitude, 
	});

	factory Address.fromJson(Map<String, dynamic> json) => Address(
				streetAddress: json['streetAddress'] as String?,
				city: json['city'] as String?,
				latitude: json['latitude'] as int?,
				longitude: json['longitude'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'streetAddress': streetAddress,
				'city': city,
				'latitude': latitude,
				'longitude': longitude,
			};

	@override
	List<Object?> get props => [streetAddress, city, latitude, longitude];
}
