import 'package:employee/data/global/extension/data_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

const padding = 15.0;

enum CalendarOption { option1, option2 }

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({
    required this.option,
    this.initialDate,
    this.option2InitialDate,
    super.key,
  });

  final CalendarOption option;
  final DateTime? initialDate;
  final DateTime? option2InitialDate;

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late final ValueNotifier<DateTime?> selectedDate =
      ValueNotifier<DateTime?>(widget.initialDate);

  bool isDateSame(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  DateTime get nextMonday =>
      DateTime.now().add(Duration(days: 8 - DateTime.now().weekday));

  DateTime get nextTuesday =>
      DateTime.now().add(Duration(days: 9 - DateTime.now().weekday));

  DateTime get nextWeek => DateTime.now().add(const Duration(days: 7));

  bool isSelected(DateTime day) => (selectedDate.value == null)
      ? false
      : isDateSame(day, selectedDate.value!);

  void save(BuildContext context) => Navigator.pop(context, selectedDate.value);

  @override
  void dispose() {
    selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            borderRadius: BorderRadius.circular(padding),
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  dataButtons(widget.option),
                  calendar(),
                  const SizedBox(height: 10),
                  const Divider(),
                  footer(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );

  Widget footer(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/svg/icons/date.svg',
                    height: 24, width: 24),
                const SizedBox(width: 10),
                ValueListenableBuilder(
                  valueListenable: selectedDate,
                  builder: (context, value, child) =>
                      Text(value == null ? "No date" : value.to_d_MMM_yyyy),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withOpacity(.1)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder(
                    valueListenable: selectedDate,
                    builder: (context, value, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: (selectedDate.value == null)
                            ? null
                            : () => Navigator.pop(context, selectedDate.value),
                        child: const Text("Save"),
                      );
                    }),
              ],
            ),
          ],
        ),
      );

  Widget calendar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, value, child) => TableCalendar(
                  firstDay: widget.option == CalendarOption.option2
                      ? widget.option2InitialDate!
                      : DateTime(2000),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: Icon(Icons.arrow_left_rounded, size: 30),
                    rightChevronIcon: Icon(Icons.arrow_right_rounded, size: 30),
                  ),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: widget.option == CalendarOption.option2
                      ? value ?? widget.option2InitialDate!
                      : selectedDate.value ?? DateTime.now(),
                  selectedDayPredicate: (day) => isSelected(day),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) => Center(
                      child: Text(DateFormat.E().format(day)),
                    ),
                    disabledBuilder: (context, day, focusedDay) =>
                        const SizedBox(),
                    outsideBuilder: (context, day, focusedDay) =>
                        const SizedBox(),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) =>
                      selectedDate.value = selectedDay,
                )),
      );

  Widget dataButtons(CalendarOption option) =>
      ValueListenableBuilder<DateTime?>(
          valueListenable: selectedDate,
          builder: (context, value, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: option == CalendarOption.option1
                    ? Column(
                        children: [
                          Row(
                            children: [
                              button(
                                isSelected: isSelected(DateTime.now()),
                                onPressed: () =>
                                    selectedDate.value = DateTime.now(),
                                text: "Today",
                              ),
                              const SizedBox(width: 10),
                              button(
                                isSelected: isSelected(nextMonday),
                                onPressed: () =>
                                    selectedDate.value = nextMonday,
                                text: "Next Monday",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              button(
                                onPressed: () =>
                                    selectedDate.value = nextTuesday,
                                isSelected: isSelected(nextTuesday),
                                text: "Next Tuesday",
                              ),
                              const SizedBox(width: 10),
                              button(
                                isSelected: isSelected(nextWeek),
                                onPressed: () => selectedDate.value = nextWeek,
                                text: "After 1 week",
                              )
                            ],
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              button(
                                isSelected: selectedDate.value == null,
                                onPressed: () =>
                                    selectedDate.value = DateTime.now(),
                                text: "No Date",
                              ),
                              const SizedBox(width: 10),
                              button(
                                isSelected: isSelected(DateTime.now()),
                                onPressed: () {
                                  if (option == CalendarOption.option2) {
                                    if (!DateTime.now()
                                        .isAfter(widget.option2InitialDate!)) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Please select a date after ${widget.option2InitialDate!.to_d_MMM_yyyy}"),
                                        ),
                                      );
                                    } else {
                                      selectedDate.value = DateTime.now();
                                    }
                                  }
                                },
                                text: "Today",
                              ),
                            ],
                          ),
                        ],
                      ),
              ));

  Widget button(
          {required bool isSelected,
          required String text,
          required VoidCallback? onPressed}) =>
      Expanded(
        child: isSelected
            ? ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(elevation: 0),
                child: Text(text),
              )
            : TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor.withOpacity(.1)),
                ),
                onPressed: onPressed,
                child: Text(text),
              ),
      );
}
