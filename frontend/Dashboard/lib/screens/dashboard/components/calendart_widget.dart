import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/models/data.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/calendar_list_widget.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../Services/APIServices.dart';
import '../../../models/ListReservationResponseModel.dart';
import '../../../models/ReservationModel.dart';

class CalendarWidget extends StatefulWidget {

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<CalendarData> _selectedDate = [];
  List<CalendarData> calendarData = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<CalendarData> _eventLoader(DateTime date) {
    return calendarData
        .where((element) => isSameDay(date, element.date))
        .toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDate = calendarData
            .where((element) => isSameDay(selectedDay, element.date))
            .toList();
      });
    }
  }

  Future<List<ReservationModel>> _fetch() async {
    List<ReservationModel>   recentReservations = [];
    calendarData = [];
    await APIService.listReservation().then((value) => {

      for (ListReservationResponseModel reservation in value) {
        calendarData.add(CalendarData(
          name: reservation.user_id!,
          date: reservation.start_date!,
          position: reservation.start_date!.toString()+"->" + reservation.end_date!.toString() ,
        ))
      }
    }


    );
    return(recentReservations);

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
                backgroundColor: Colors.blue);
          }
          else {
           return   Container(
             decoration: BoxDecoration(
                 color: secondaryColor, borderRadius: BorderRadius.circular(10)),

             child: Column(
               children: [
                 Text("Reservations Calendar", style: TextStyle(fontSize: 17)),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       "${DateFormat("MMM, yyyy").format(_focusedDay)}",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                     ),
                     Row(
                       children: [
                         InkWell(
                           onTap: () {
                             setState(() {
                               _focusedDay =
                                   DateTime(_focusedDay.year, _focusedDay.month - 1);
                             });
                           },
                           child: Icon(
                             Icons.chevron_left,
                             color: greenColor,
                           ),
                         ),
                         InkWell(
                           onTap: () {
                             setState(() {
                               print(_focusedDay);
                               _focusedDay =
                                   DateTime(_focusedDay.year, _focusedDay.month + 1);
                             });
                           },
                           child: Icon(
                             Icons.chevron_right,
                             color: greenColor,
                           ),
                         ),
                       ],
                     )
                   ],
                 ),
                 SizedBox(
                   height: 10,
                 ),
                 TableCalendar<CalendarData>(
                     selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
                     focusedDay: _focusedDay,
                     firstDay: DateTime.utc(2022),
                     lastDay: DateTime.utc(2025),
                     headerVisible: false,
                     onDaySelected: _onDaySelected,
                     onFormatChanged: (result) {},
                     daysOfWeekStyle: DaysOfWeekStyle(
                       dowTextFormatter: (date, locale) {
                         return DateFormat("EEE").format(date).toUpperCase();
                       },
                       weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                       weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     onPageChanged: (day) {
                       _focusedDay = day;
                       setState(() {});
                     },
                     calendarStyle: CalendarStyle(
                       todayDecoration: BoxDecoration(
                         color: greenColor,
                         shape: BoxShape.circle,
                       ),
                       markerDecoration: BoxDecoration(
                         color: greenColor,
                         shape: BoxShape.circle,
                       ),
                     ),
                     eventLoader: _eventLoader),
                 SizedBox(
                   height: 8,
                 ),

                 CalendartList(datas: _selectedDate),
               ],
             ),
           );
          }
        }
    );

  }
}
