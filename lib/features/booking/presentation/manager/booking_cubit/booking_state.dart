part of 'booking_cubit.dart';

 @immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}
final class BookingDateSelected extends BookingState {
  final DateTime selectedDate;

  BookingDateSelected(this.selectedDate); // Store the selected date
}

final class BookingTimeSlotsGenerated extends BookingState {
  final List<Map<String, String>> timeSlots;

  BookingTimeSlotsGenerated(this.timeSlots); // Store the generated time slots
}