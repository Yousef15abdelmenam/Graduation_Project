// First, modify your BookingCubit class to include the API integration

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/features/booking/data/models/booking.model.dart';
import 'package:graduation_project/features/booking/data/repos/booking_repo.dart';
import 'package:get_it/get_it.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  Map<String, Set<int>> bookedSlots = {};
  final BookingRepo bookingRepo;

  BookingCubit(this.bookingRepo)
      : super(BookingSelection(
          date: DateTime.now(),
          courtIndex: 0,
          selectedTimeIndices: [],
          timeSlots: [],
        )) {
    updateBooking(DateTime.now(), 0);
    // Load existing bookings when initialized
    fetchExistingBookings();
  }

  // Method to fetch existing bookings from API
  Future<void> fetchExistingBookings() async {
    print('Fetching existing bookings...');
    final result = await bookingRepo.getBookings();

    result.fold((failure) {
      // Handle error - log it but don't disrupt UI
      print('Failed to load bookings: ${failure.errMessage}');
      // Don't emit an error state here, just keep the current state
    }, (bookings) {
      print('Successfully loaded ${bookings.length} bookings');
      // Update local bookedSlots map with data from API
      for (var booking in bookings) {
        if (booking.courtId != null && booking.date != null) {
          final date = DateTime.parse(booking.date!);
          final courtIndex =
              booking.courtId! - 1; // Assuming courtId in API starts from 1

          // Get the time slot indices that correspond to the booking's time range
          final startTime = booking.startTime != null
              ? DateTime.parse(booking.startTime!)
              : null;
          final endTime =
              booking.endTime != null ? DateTime.parse(booking.endTime!) : null;

          if (startTime != null && endTime != null) {
            final slotIndices = _getSlotIndicesForTimeRange(startTime, endTime);

            for (var slotIndex in slotIndices) {
              bookSlot(courtIndex, date, slotIndex);
            }
          }
        }
      }

      // Refresh the UI with updated booked slots
      if (state is BookingSelection) {
        final current = state as BookingSelection;
        updateBooking(current.date, current.courtIndex);
      }
    });
  }
  
  // Helper method to find which slot indices correspond to a time range
  List<int> _getSlotIndicesForTimeRange(DateTime startTime, DateTime endTime) {
    List<int> indices = [];
    List<Map<String, String>> timeSlots = generateTimeSlots(
        DateTime(startTime.year, startTime.month, startTime.day));

    for (int i = 0; i < timeSlots.length; i++) {
      DateTime slotStart = DateTime.parse(timeSlots[i]['startTime']!);
      DateTime slotEnd = DateTime.parse(timeSlots[i]['endTime']!);

      // Check if this slot overlaps with the booking time range
      if ((slotStart.isAtSameMomentAs(startTime) ||
              slotStart.isAfter(startTime)) &&
          (slotEnd.isAtSameMomentAs(endTime) || slotEnd.isBefore(endTime))) {
        indices.add(i);
      }
    }

    return indices;
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

  Future<bool> confirmBooking(DateTime selectedDate, int courtIndex, List<int> selectedTimeIndices) async {
    if (selectedTimeIndices.isEmpty) {
      emit(BookingError('No time slots selected'));
      return false;
    }

    // Validate slots
    for (var index in selectedTimeIndices) {
      if (index is! int) {
        print('Invalid index type in selectedTimeIndices: $index (${index.runtimeType})');
        emit(BookingError('Invalid time slot index type'));
        return false;
      }
      if (isSlotBooked(selectedDate, courtIndex, index)) {
        emit(BookingError('Selected slot is already booked'));
        return false;
      }
      if (isPastTimeSlot(DateTime.parse(generateTimeSlots(selectedDate)[index]['startTime']!))) {
        emit(BookingError('Selected slot is in the past'));
        return false;
      }
    }

    emit(BookingLoading());
    final timeSlots = generateTimeSlots(selectedDate);
    List<List<int>> groupedIndices = _groupConsecutiveIndices(selectedTimeIndices);
    bool allSuccess = true;

    for (var group in groupedIndices) {
      if (group.isEmpty) continue;

      print('Processing group: $group'); // Debug group contents
      for (var index in group) {
        if (index is! int) {
          print('Invalid index type in group: $index (${index.runtimeType})');
          emit(BookingError('Invalid group index type'));
          return false;
        }
      }

      final startSlotIndex = group.first;
      final endSlotIndex = group.last;

      final startTimeString = timeSlots[startSlotIndex]['startTime'];
      final endTimeString = timeSlots[endSlotIndex]['endTime'];

      final booking = BookingModel(
        courtId: courtIndex + 1,
        date: selectedDate.toIso8601String().split('T').first,
        startTime: startTimeString,
        endTime: endTimeString,
      );

      print('Booking payload: ${booking.toJson()}');
      final result = await bookingRepo.confirmBookingApi(booking);

      result.fold(
        (failure) {
          print('Booking failed: ${failure.errMessage}');
          emit(BookingError(failure.errMessage));
          allSuccess = false;
          if (failure.errMessage.contains('Authentication required') || failure.errMessage.contains('401')) {
            throw Exception('Authentication required: ${failure.errMessage}');
          }
        },
        (success) {
          if (success) {
            for (var index in group) {
              bookSlot(courtIndex, selectedDate, index);
            }
          } else {
            emit(BookingError('Booking failed'));
            allSuccess = false;
          }
        },
      );
    }

    // Always re-emit BookingSelection state with updated data to refresh UI
    // Keep the CURRENT selected date rather than resetting to today
    final updatedTimeSlots = generateTimeSlots(selectedDate);
    emit(BookingSelection(
      date: selectedDate,  // Keep the selected date, don't reset to today
      courtIndex: courtIndex,
      selectedTimeIndices: [],
      timeSlots: updatedTimeSlots,
    ));

    if (allSuccess) {
      emit(BookingSuccess());
      // Add short delay before switching back to BookingSelection state
      await Future.delayed(Duration(milliseconds: 200));
      emit(BookingSelection(
        date: selectedDate,  // Keep the selected date here too
        courtIndex: courtIndex,
        selectedTimeIndices: [],
        timeSlots: updatedTimeSlots,
      ));
    }

    return allSuccess;
  }

  // Helper method to group consecutive indices
  List<List<int>> _groupConsecutiveIndices(List<int> indices) {
    if (indices.isEmpty) return [];
    indices.sort();
    List<List<int>> groups = [];
    List<int> currentGroup = [indices.first];

    for (int i = 1; i < indices.length; i++) {
      if (indices[i] == indices[i - 1] + 1) {
        currentGroup.add(indices[i]);
      } else {
        groups.add(currentGroup);
        currentGroup = [indices[i]];
      }
    }
    groups.add(currentGroup);
    return groups;
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
    final dateKey =
        "${selectedDate.toIso8601String().split('T').first}_court_$courtIndex";

    if (!bookedSlots.containsKey(dateKey)) {
      bookedSlots[dateKey] = Set<int>();
    }

    bookedSlots[dateKey]?.add(slotIndex);
  }

  bool isSlotBooked(DateTime selectedDate, int courtIndex, int slotIndex) {
    final dateKey =
        "${selectedDate.toIso8601String().split('T').first}_court_$courtIndex";
    return bookedSlots[dateKey]?.contains(slotIndex) ?? false;
  }

  bool isPastTimeSlot(DateTime slotTime) {
    DateTime now = DateTime.now();
    DateTime currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    return currentTime.isAfter(slotTime);
  }
}