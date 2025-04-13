import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/features/booking/presentation/manager/booking_cubit/booking_cubit.dart';
import 'package:graduation_project/features/facilities/presentation/views/widgets/date_picker.dart';

class BookingViewBody extends StatefulWidget {
  const BookingViewBody({super.key});

  @override
  State<BookingViewBody> createState() => _BookingViewBodyState();
}

class _BookingViewBodyState extends State<BookingViewBody> {
  int? selectedCourtIndex = 0; // Track the selected court (single selection)
  List<int> selectedTimeIndices = []; // Track multiple selected time slots

  List<String> courts = [
    "Court 1",
    "Court 2",
    "Court 3",
    "Court 4"
  ]; // Court names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        title: const Text("Cairo Stadium",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          // Ensure there's a selected date, default to now if not
          DateTime selectedDate = DateTime.now();
          if (state is BookingDateSelected) {
            selectedDate = state.selectedDate;
          }

          // Generate time slots based on the selected date
          List<Map<String, String>> timeSlots = context.read<BookingCubit>().generateTimeSlots(selectedDate);

          return Column(
            children: [
              const DatePickerWidget(), // Date picker widget for date selection
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCourtIndex = index; // Single selection for courts
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: selectedCourtIndex == index
                              ? Colors.green // Selected color
                              : Colors.grey[800], // Default color
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          courts[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '300 EGP',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Court Size : 5 vs 5',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final startTime = DateTime.parse(timeSlots[index]['startTime']!);

                    // Check if the selected date is today and if the time has passed
                    bool isToday = selectedDate.isAtSameMomentAs(DateTime.now());
                    bool isPastTime = isToday && context.read<BookingCubit>().isPastTimeSlot(startTime);

                    return GestureDetector(
                      onTap: isPastTime
                          ? null // Disable selection for past times
                          : () {
                              setState(() {
                                if (selectedTimeIndices.contains(index)) {
                                  selectedTimeIndices.remove(index); // Deselect if already selected
                                } else {
                                  selectedTimeIndices.add(index); // Add to selected list
                                }
                              });
                            },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isPastTime
                                  ? Colors.red // Red for past times
                                  : selectedTimeIndices.contains(index)
                                      ? kPrimaryColor // Selected color
                                      : Colors.grey[800], // Default color
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  timeSlots[index]['start']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: isPastTime
                                        ? Colors.black // Text color for disabled time
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.arrow_forward,
                                    size: 30, color: Colors.white),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  timeSlots[index]['end']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: isPastTime
                                        ? Colors.black // Text color for disabled time
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
