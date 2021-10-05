import 'package:flutter/material.dart';
import 'package:jilju/util.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'database.dart';
import 'message.dart';
import 'model/jilju.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState()
      : _startDate = today(),
        _endDate = today();

  DateTime _startDate;
  DateTime _endDate;

  Future<PickerDateRange?> _showDatePickerDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AspectRatio(
            aspectRatio: 0.6,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(_startDate, _endDate),
                showActionButtons: true,
                onSubmit: (value) => Navigator.pop(context, value),
                onCancel: () => Navigator.pop(context),
              ),
            ),
          ),
        );
      },
    );
  }

  ListView _buildListViewOfJiljus(List<Jilju> jiljuList) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.directions_run, size: 20),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        '${dateToString(secondsToDateTime(jiljuList[index].startTime))}\n'
                        '${timeToString(secondsToDateTime(jiljuList[index].startTime))}'
                        ' ~ ${timeToString(secondsToDateTime(jiljuList[index].endTime))}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${jiljuList[index].distance.toStringAsFixed(1)} km\n'
                        '${durationToString(jiljuList[index].totalTime())}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: jiljuList.length,
    );
  }

/*
  ListView _buildListViewOfJiljus(List<Jilju> jiljuList) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.directions_run, size: 20),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${dateTimeToString(secondsToDateTime(jiljuList[index].startTime))}'
                            ' ~ ${timeToString(secondsToDateTime(jiljuList[index].endTime))}',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                '${jiljuList[index].distance.toStringAsFixed(1)} km',
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                durationToString(jiljuList[index].totalTime()),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: jiljuList.length,
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseManager.getJiljuLists(
          _startDate, _endDate.difference(_startDate).inDays + 1),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<List<Jilju>> jiljuLists = snapshot.data as List<List<Jilju>>;
          List<Jilju> totalJiljuList =
              jiljuLists.reduce((a, b) => [...a, ...b]);
          return Column(
            children: <Widget>[
              InkWell(
                child: SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.event_note, size: 20),
                        Expanded(
                          child: Center(
                            child: Text(
                                '${dateToString(_startDate)} ~ ${dateToString(_endDate)}',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () async {
                  PickerDateRange? pickerDateRange =
                      await _showDatePickerDialog();
                  if (pickerDateRange == null) {
                    return;
                  }
                  setState(() {
                    _startDate = pickerDateRange.startDate!;
                    _endDate = pickerDateRange.endDate ?? _startDate;
                  });
                },
              ),
              const Divider(),
              Expanded(
                  child: totalJiljuList.isEmpty
                      ? Center(
                          child: Text(
                            MessageManager.messageString[6],
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      : _buildListViewOfJiljus(totalJiljuList)),
            ],
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          return const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
