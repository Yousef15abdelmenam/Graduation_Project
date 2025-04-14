import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';

class BottomBookingConfirmation extends StatelessWidget {
  const BottomBookingConfirmation({
    super.key,
    required this.selectedDate,
    required this.timeSlots,
    required this.selectedTimeIndices,
  });

  final DateTime selectedDate;
  final List<Map<String, String>> timeSlots;
  final List<int> selectedTimeIndices;

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

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('EEE, MMM d').format(selectedDate);
    final groupedSlots = _groupConsecutiveIndices(selectedTimeIndices);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: kBackGroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),

            // Time ranges
            Column(
              children: groupedSlots.map((group) {
                final start = timeSlots[group.first]['start'];
                final end = timeSlots[group.last]['end'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$start to $end",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 6),
            Divider(
              height: 16,
              thickness: 0.8,
              color: Colors.grey[700],
            ),

            const Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 6),
              child: Text(
                'You can cancel a booking no later than 4 hours from its starting time',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '300 EGP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Slide confirmation
            Builder(
              builder: (context) {
                return SizedBox(
                  height: 50,
                  child: SlideAction(
                    outerColor: Colors.green,
                    innerColor: Colors.white,
                    elevation: 1,
                    borderRadius: 12,
                    text: "Slide To Confirm",
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    sliderButtonIcon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 16, // smaller icon
                    ),
                    onSubmit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Booking Confirmed!")),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
