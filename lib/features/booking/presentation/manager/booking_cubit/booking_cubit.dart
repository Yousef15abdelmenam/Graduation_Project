import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  void selectDate(DateTime selectedDate) {
    emit(BookingDateSelected(selectedDate));
  }

// Generate time slots starting from 6:00 AM for 24 hours
  List<Map<String, String>> generateTimeSlots(DateTime selectedDate) {
    List<Map<String, String>> timeSlots = [];
    
    DateTime startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 6, 0); // Start at 6 AM

    for (int i = 0; i < 24; i++) { // 24 time slots
      DateTime endTime = startTime.add(Duration(hours: 1)); // Each time slot lasts 1 hour
      timeSlots.add({
        'start': "${startTime.hour > 12 ? startTime.hour - 12 : startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ${startTime.hour >= 12 ? 'PM' : 'AM'}", // Format start time (AM/PM)
        'end': "${endTime.hour > 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute.toString().padLeft(2, '0')} ${endTime.hour >= 12 ? 'PM' : 'AM'}", // Format end time (AM/PM)
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      });

      // Move to next hour
      startTime = endTime;
    }

    return timeSlots;
  }

  // Method to check if time slot is in the past
  bool isPastTimeSlot(DateTime slotTime) {
    DateTime now = DateTime.now();
    
    // Get current time without seconds for comparison
    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute); 

    return currentTime.isAfter(slotTime); // Return true if current time is past the slot time
  }
}