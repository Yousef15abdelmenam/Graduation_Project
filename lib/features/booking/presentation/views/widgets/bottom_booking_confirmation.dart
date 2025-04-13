import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView( // Added scroll for dynamic content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Date and time details (condensed)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date:',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                Text(
                  '${selectedDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time:',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                Text(
                  '${timeSlots[selectedTimeIndices.first]['start']} - ${timeSlots[selectedTimeIndices.last]['end']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price info and button in a condensed form
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Price:',
                  style: TextStyle(
                    fontSize: 14,
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
            const SizedBox(height: 10),

            // Condensed confirmation button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
