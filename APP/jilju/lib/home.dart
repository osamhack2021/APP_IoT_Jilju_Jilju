import 'package:flutter/material.dart';
import 'chart.dart';

// const Color darkBlue = Color.fromARGB(255, 18, 32, 47); 색상 상수 예시

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name = 'Sungmin Woo'; // user name
  var totalDistance = 12.4;
  var selectedDayDistance = 2.7;
  // var totalTime = ; // 시간 데이터형 공부하기
  // var selectedDayDistance = ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Customized Report'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, $name!',
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 96,
                    child: Card(
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Center(
                        child: Text(
                          '${totalDistance}km',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ), // Center
                    ), // 뛴 거리 카드
                  ), // Container
                ), // Expanded
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 96,
                    child: Card(
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: const Center(
                        child: Text(
                          '00:56:30',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ), // Center
                    ), // 뛴 시간 카드
                  ), // Container
                ), // Expanded
              ],
            ),

            const SizedBox(
              height: 16,
            ), // 여백

            // 차트 카드

            SizedBox(
              height: 480,
              child: Card(
                color: Colors.black,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: const Center(
                  // 차트 삽입할 부분
                  child: ChartWidget(),
                  /*
                  Text(
                    'Chart Widget Card',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  */
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ), // 여백

            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 96,
                    child: Card(
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Center(
                        child: Text(
                          '${selectedDayDistance}km',
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white),
                        ),
                      ),
                    ), // 특정 뛴 거리 카드
                  ), // Container
                ), // Expanded
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 96,
                    child: Card(
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: const Center(
                        child: Text(
                          '00:10:30',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ), // 특정 뛴 시간 카드
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 리스트뷰
// Row/총 뛴 거리 카드/총 뛴 시간 카드
// 총 뛴 거리 카드 ( TexField, 숫자 뛰울 박스, 변수로 데이터 받아오기  )
// 총 뛴 시간 카드 ( 거리 카드랑 동일 ) 

// 차트 카드
// ChartWidget 가져오기
// DB 연동
// ChartRodData(개별 막대 그래프) 클릭 시, 그날 뛴 기록 하단에 띄워주기
// Fl_chart Touch 특성 사용

// 하단 표시 순서도 뛴 거리/시간 디자인 비슷하게 아래에 적용