import 'dart:ui';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracking_works/config.dart';
import 'package:tracking_works/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(
        title: 'LoginScreen',
      ),
    );
  }
}

class CardItem {
  final String titleNull;
  final String timerNull;
  final String absent;
  final Color color;
  final Color colors;

  const CardItem({
    required this.titleNull,
    required this.timerNull,
    required this.absent,
    required this.color,
    required this.colors,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final String _baseUrl = 'https://krista-staging.trackingworks.io';

  bool _isLoading = false;
  String _shiftDate = '-';
  String _shiftPeriod = '-';
  List<CardItem> items = [];

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Tugas'),
    Text('Laporan'),
    Text('Profil'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    DateFormat formatter = DateFormat('EEE, d MMM yyyy', 'id');
    _shiftDate = formatter.format(DateTime.now());

    super.initState();
    items = [
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Hadir',
          color: Colors.teal.shade50,
          colors: Colors.greenAccent.shade400),
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Keluar awal',
          color: Colors.orange.shade50,
          colors: Colors.orangeAccent),
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Terlambat',
          color: Colors.blueGrey.shade50,
          colors: Colors.blueGrey.shade300),
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Cuti',
          color: Colors.blue.shade50,
          colors: Colors.blueAccent.shade100),
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Tidak Hadir',
          color: Colors.red.shade100,
          colors: Colors.red),
      CardItem(
          titleNull: '0',
          timerNull: '0 Jam 0 Menit',
          absent: 'Libur',
          color: Colors.purple.shade100,
          colors: Colors.purple),
    ];
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
              Spacer(),
              Container(
                child: Text(
                  'ESCA HRIS',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )),
      body: FutureBuilder<void>(
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildBody();
              }
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 16,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            title: Text(
              'Tugas',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            title: Text(
              'Laporan',
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            title: Text(
              'Profil',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required CardItem item,
  }) =>
      Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, top: 10, bottom: 15, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: item.color,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titleNull,
                  style: TextStyle(
                      color: item.colors,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  item.timerNull,
                  style: TextStyle(color: item.colors, fontSize: 13),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: item.colors,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.absent,
                      style: TextStyle(color: item.colors, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );

  Widget _buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Form(
          child: Column(children: [
            Container(
              height: 200,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      bottomRight: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0))),
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          _shiftDate,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          _shiftPeriod,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 20),
                        ),
                        Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                AssetImage("assets/images/salma.jpg"),
                                maxRadius: 25,
                                minRadius: 25,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Halo,'),

                                        Text('Salma Muntaz Shaumi'),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'salmamumtazsaomi@gmail.com',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await Configuration().postAttendance(context);
                            },
                            child: Text('Jam Masuk',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Simpulan Kehadiran (Nov 2021)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: ListView.separated(
                        itemCount: 6,
                        separatorBuilder: (context, _) => SizedBox(
                          width: 12,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            buildCard(item: items[index])),
                  )
                ],
              ),
            ),
            Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Papan Pengumuman",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "Lihat Semua",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Text('Test Descriprtion Notice'),
                              SizedBox(
                                height: 5,
                              ),
                              Text(_shiftDate),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
