import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'model/jilju.dart';
import 'database.dart';

/*
class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Fl_graph example #1",
      home: ChartWidget(),
    );
  }
}
*/

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text(
          "Fl Chart Example #1",
        ),
        foregroundColor: Colors.green, // 텍스트 및 아이콘(?) 색상
        backgroundColor: Colors.white, // 배경 색상
      ),
      */
      body: Card(
        elevation: 0.3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.only(left: 32, right: 32),
        color: const Color(0x99181a1f), // 투명도 살짝 적용
        child: const Center(
          child: _BarChart(),
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child:*/
        Expanded(
      child: BarChart(
        BarChartData(
          titlesData: titlesData,
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceEvenly,
          // alignment: BarChartAlignment.center + groupsSpace: 16,
          maxY: 120,
        ),
      ),
    );
  }
}

FlTitlesData get titlesData => FlTitlesData(
      show: true, // titles 표시 활성화

      bottomTitles: SideTitles(
        // x축 titles 표시
        showTitles: true,
        reservedSize: 50,
        getTextStyles: (context, value) => const TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),

      leftTitles: SideTitles(
        // y축 titles 표시
        showTitles: true,
        reservedSize: 50,
        getTextStyles: (context, value) => const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),

      /* 제목 설정하기
      getTitles: (double value) {
        switch (value.toInt()) {
          case 0:
          return
        }
      },
      */

      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    );

// **************************************************************************
// 2021-10-02

// 예시 날짜
DateTime selectedFromDateTime = DateTime.utc(2021, 9, 30);
DateTime selectedToDateTime = DateTime.utc(2021, 10, 3);

// sample data // 현재 날짜, 이전날짜, 이틀전날짜 3일치
List<Jilju> jiljuList =
    DatabaseManager.getJiljuList(selectedFromDateTime, selectedToDateTime)
        as List<Jilju>;

List<BarChartRodData> getBarRods() {
  List<BarChartRodData> newBarRods = [];

  for (int i = 0; i < jiljuList.length; i++) {
    newBarRods.add( // newBarRods = newBarRods.add
      BarChartRodData(
        y: jiljuList[i].distance,
        colors: [Colors.amber],
        width: 32, // 개수에 따라 변하게 추후 수정 필요
        borderRadius:
            const BorderRadius.vertical(top: Radius.zero, bottom: Radius.zero),
      ),
    );
  }
  return newBarRods;
}

// **************************************************************************

List<BarChartGroupData> get barGroups => [
      BarChartGroupData(
        x: 0, // 얘는 어떻게 사용해야 할까?
        barsSpace: 32,
        barRods: getBarRods(),
        /*[
          BarChartRodData(
            y: 100,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 36,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 72,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 48,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 21,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 84,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
          BarChartRodData(
            y: 50,
            colors: [Colors.blue],
            width: 32,
            borderRadius: const BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.zero),
          ),
        ],
        */
        //showingTooltipIndicators: [0],
      ), // ?
    ];

/* 
참고자료
- https://www.google.com/search?q=bar+chart&tbm=isch&ved=2ahUKEwiAy4S4-J7zAhVYFIgKHUFnAEoQ2-cCegQIABAA&oq=bar+chart&gs_lcp=CgNpbWcQAzIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIECAAQHjoICAAQgAQQsQM6CwgAEIAEELEDEIMBOgQIABADUKUHWLQtYMguaAVwAHgAgAF3iAGADJIBBDUuMTCYAQCgAQGqAQtnd3Mtd2l6LWltZ7ABAMABAQ&sclient=img&ei=SZxRYcCCIdiooATBzoHQBA&bih=950&biw=942&client=ubuntu&hs=jar#imgrc=JIzbUfeYSt1DmM

*/

// getJiljuList()에서 데이터 받아와서 futureBuilder()로 BarChartRodData 생성하기
/*
https://eory96study.tistory.com/33

FutureBuilder(
  future: getJiljuList(),
  builder: (context, AsyncSnapshot<> snapshot) {
    // 데이터 들어오지 않으면 로딩
    if (snapshot.hasData == false) {
      return CircularProgressIndicator();
    }
    return BarChartRodData(
      y: 
      colors: [],
      borderRadious: const.borderRadius.vertical(
        top: Raduis.zero, bottom: Radius.zero,
      ),
    );
  }
);


createBarChartRodData() {

}

*/
