import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/features/booking/presentation/manager/booking_cubit/booking_cubit.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedValue = DateTime.now(); // Track selected date

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a date:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SizedBox(
            // FIX: Ensure DatePicker has a defined height
            height: 100, // Adjust as needed
            child: DatePicker(
              DateTime.now(),
              daysCount: 7,
              initialSelectedDate: _selectedValue,
              selectionColor: kPrimaryColor,
              selectedTextColor: Colors.white,
              dayTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              monthTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              dateTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedValue = date;
                });
                context.read<BookingCubit>().selectDate(date);
              },
            ),
          ),
        ],
      ),
    );
  }
}
