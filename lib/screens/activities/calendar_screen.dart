import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:church_information_system/controllers/activities_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends GetView<ActivitiesController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
          ),
        ],
      ),
    );
  }
}
