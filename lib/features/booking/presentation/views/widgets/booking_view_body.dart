import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/features/booking/presentation/manager/booking_cubit/booking_cubit.dart';
import 'package:graduation_project/features/booking/presentation/views/widgets/bottom_booking_confirmation.dart';
import 'package:graduation_project/features/facilities/presentation/views/widgets/date_picker.dart';

class BookingViewBody extends StatefulWidget {
  const BookingViewBody({super.key});

  @override
  State<BookingViewBody> createState() => _BookingViewBodyState();
}

class _BookingViewBodyState extends State<BookingViewBody> {
  int? selectedCourtIndex = 0;
  List<int> selectedTimeIndices = [];

  List<String> courts = ["Court 1", "Court 2", "Court 3", "Court 4"];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<BookingCubit>();
    final state = cubit.state;
    if (state is BookingSelection) {
      cubit.updateBooking(state.date, state.courtIndex);
    }
  }

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
      body: BlocBuilder<BookingCubit, BookingState>(builder: (context, state) {
        DateTime selectedDate = DateTime.now();
        int selectedCourt = 0;
        List<Map<String, String>> timeSlots = [];

        if (state is BookingSelection) {
          selectedDate = state.date;
          selectedCourt = state.courtIndex;
          timeSlots = state.timeSlots;
        }

        return Column(
          children: [
            const DatePickerWidget(),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCourtIndex = index;
                        selectedTimeIndices.clear(); // Reset selected times
                      });
                      context
                          .read<BookingCubit>()
                          .updateCourt(selectedCourtIndex ?? 0);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: selectedCourtIndex == index
                            ? Colors.green
                            : Colors.grey[800],
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
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('300 EGP', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Text('Court Size : 5 vs 5', style: TextStyle(fontSize: 18))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final startTime =
                      DateTime.parse(timeSlots[index]['startTime']!);
                  bool isToday = selectedDate.day == DateTime.now().day &&
                      selectedDate.month == DateTime.now().month &&
                      selectedDate.year == DateTime.now().year;
                  bool isPastTime = isToday &&
                      context.read<BookingCubit>().isPastTimeSlot(startTime);
                  bool isBooked = context.read<BookingCubit>().isSlotBooked(
                      selectedDate, selectedCourtIndex ?? 0, index);

                  return GestureDetector(
                    onTap: isPastTime || isBooked
                        ? null
                        : () {
                            setState(() {
                              if (selectedTimeIndices.contains(index)) {
                                selectedTimeIndices.remove(index);
                              } else {
                                selectedTimeIndices.add(index);
                              }
                              context
                                  .read<BookingCubit>()
                                  .updateSelectedTimes(selectedTimeIndices);
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
                                ? Colors.red
                                : selectedTimeIndices.contains(index)
                                    ? Colors.green
                                    : Colors.grey[800],
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
                                  color:
                                      isPastTime ? Colors.white : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward,
                                  size: 30, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                timeSlots[index]['end']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isPastTime ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 👇 Bottom confirmation container
if (selectedTimeIndices.isNotEmpty)
BottomBookingConfirmation(selectedDate: selectedDate, timeSlots: timeSlots, selectedTimeIndices: selectedTimeIndices)
          ],
        );
      }),
    );
  }
}
