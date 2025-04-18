import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  Map<String, Set<int>> bookedSlots = {};
  

  BookingCubit()
      : super(BookingSelection(
          date: DateTime.now(),
          courtIndex: 0,
          selectedTimeIndices: [],
          timeSlots: [],
        )) {
    updateBooking(DateTime.now(), 0);
  }

  void selectDate(DateTime selectedDate) {
    if (state is BookingSelection) {
      final current = state as BookingSelection;
      final timeSlots = generateTimeSlots(selectedDate);
      emit(current.copyWith(
        date: selectedDate,
        timeSlots: timeSlots,
        selectedTimeIndices: [],
      ));
    }
  }

  void confirmBooking(List<int> selectedTimeIndices) {
    final currentState = state;
    if (currentState is BookingSelection) {
      // Update the state with the confirmed time slots
      emit(currentState.copyWith(
        selectedTimeIndices: selectedTimeIndices,
      ));
    }
  }

  void updateCourt(int courtIndex) {
    if (state is BookingSelection) {
      final current = state as BookingSelection;
      final timeSlots = generateTimeSlots(current.date);
      emit(current.copyWith(
        courtIndex: courtIndex,
        timeSlots: timeSlots,
        selectedTimeIndices: [],
      ));
    }
  }

  void updateSelectedTimes(List<int> selectedTimeIndices) {
    if (state is BookingSelection) {
      final current = state as BookingSelection;
      emit(current.copyWith(selectedTimeIndices: selectedTimeIndices));
    }
  }

  void updateDate(DateTime date) {
    if (state is BookingSelection) {
      final current = state as BookingSelection;
      final timeSlots = generateTimeSlots(date);
      emit(current.copyWith(
        date: date,
        timeSlots: timeSlots,
        selectedTimeIndices: [],
      ));
    }
  }

  void updateBooking(DateTime date, int courtIndex) {
    final timeSlots = generateTimeSlots(date);
    emit(BookingSelection(
      date: date,
      courtIndex: courtIndex,
      selectedTimeIndices: [],
      timeSlots: timeSlots,
    ));
  }

  List<Map<String, String>> generateTimeSlots(DateTime date) {
    List<Map<String, String>> timeSlots = [];
    DateTime startTime = DateTime(date.year, date.month, date.day, 6, 0);

    for (int i = 0; i < 24; i++) {
      DateTime endTime = startTime.add(const Duration(hours: 1));
      timeSlots.add({
        'start':
            "${startTime.hour > 12 ? startTime.hour - 12 : startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ${startTime.hour >= 12 ? 'PM' : 'AM'}",
        'end':
            "${endTime.hour > 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute.toString().padLeft(2, '0')} ${endTime.hour >= 12 ? 'PM' : 'AM'}",
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      });
      startTime = endTime;
    }

    return timeSlots;
  }

  void bookSlot(int courtIndex, DateTime selectedDate, int slotIndex) {
    final dateKey = "${selectedDate.toIso8601String()}_court_$courtIndex";

    if (!bookedSlots.containsKey(dateKey)) {
      bookedSlots[dateKey] = Set<int>();
    }

    bookedSlots[dateKey]?.add(slotIndex);
  }

  bool isSlotBooked(DateTime selectedDate, int courtIndex, int slotIndex) {
    final dateKey = "${selectedDate.toIso8601String()}_court_$courtIndex";
    return bookedSlots[dateKey]?.contains(slotIndex) ?? false;
  }

  bool isPastTimeSlot(DateTime slotTime) {
    DateTime now = DateTime.now();
    DateTime currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    return currentTime.isAfter(slotTime);
  }
}
