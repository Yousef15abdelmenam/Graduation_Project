import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
	final int? courtId;
	final String? date;
	final String? startTime;
	final String? endTime;

	const BookingModel({this.courtId, this.date, this.startTime, this.endTime});

	factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
				courtId: json['courtId'] as int?,
				date: json['date'] as String?,
				startTime: json['startTime'] as String?,
				endTime: json['endTime'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'courtId': courtId,
				'date': date,
				'startTime': startTime,
				'endTime': endTime,
			};

	@override
	List<Object?> get props => [courtId, date, startTime, endTime];
}
