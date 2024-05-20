// import 'package:demoapp/pages/showcase_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'attendance_details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey keyOne = GlobalKey();
  final GlobalKey keyTwo = GlobalKey();
  final GlobalKey keyThree = GlobalKey();

  late bool _isTimeAgoFormat;

  // define a ScrollController
  final ScrollController _scrollController = ScrollController();

  // boolean to track if the end of the list is reached
  bool _isEndOfListReached = false;

  // input field for users to add new record
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // display list of attendance record dataset
  List<Map<String, dynamic>> _allAttendance = [
    {
      "user": "Chan Saw Lin",
      "phone": "0152131113",
      "checkIn": "2020-06-30 16:10:05"
    },
    {
      "user": "Lee Saw Loy",
      "phone": "0161231346",
      "checkIn": "2020-07-11 15:39:59"
    },
    {
      "user": "Khaw Tong Lin",
      "phone": "0158398109",
      "checkIn": "2020-08-19 11:10:18"
    },
    {
      "user": "Lim Kok Lin",
      "phone": "0168279101",
      "checkIn": "2020-08-19 11:11:35"
    },
    {
      "user": "Low Jun Wei",
      "phone": "0112731912",
      "checkIn": "2020-08-15 13:00:05"
    },
    {
      "user": "Yong Weng Kai",
      "phone": "0172332743",
      "checkIn": "2020-07-31 18:10:11"
    },
    {
      "user": "Jayden Lee",
      "phone": "0191236439",
      "checkIn": "2020-08-22 08:10:38"
    },
    {
      "user": "Kong Kah Yan",
      "phone": "0111931233",
      "checkIn": "2020-07-11 12:00:00"
    },
    {
      "user": "Jasmine Lau",
      "phone": "0162879190",
      "checkIn": "2020-08-01 12:10:05"
    },
    {
      "user": "Chan Saw Lin",
      "phone": "016783239",
      "checkIn": "2020-08-23 11:59:05"
    }
  ];

  List<Map<String, dynamic>> _foundAttendance = [];

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.isNewUser) {
    //     // ShowCaseWidget.of(context).startShowCase([keyOne, keyTwo, keyThree]);
    //   }
    // });

    _foundAttendance = _allAttendance; // filter attendance record

    _loadTimeFormatPreference();

    // add a listener to the scroll controller
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  // to handle scroll events
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // if the end of the list is reached, set _isEndOfListReached to true
      setState(() {
        _isEndOfListReached = true;
      });
    } else {
      // if not, hide the indicator
      setState(() {
        _isEndOfListReached = false;
      });
    }
  }

  // filter search keyword input by users
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty
      results = _allAttendance;
    } else {
      results = _allAttendance.where((user) {
        String checkInText;
        DateTime checkInDate = DateTime.parse(user["checkIn"]);
        if (_isTimeAgoFormat) {
          checkInText = timeago.format(checkInDate);
        } else {
          checkInText = DateFormat('dd MMM yyyy, h:mm a').format(checkInDate);
        }
        return user["user"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            checkInText.toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();
    }

    setState(() {
      _foundAttendance = results;
    });
  }

  // load saved time format
  void _loadTimeFormatPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isTimeAgoFormat = prefs.getBool('timeFormatPreference') ?? true;
    });
  }

  // save time format
  void _saveTimeFormatPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('timeFormatPreference', value);
  }

  // method adding new attendance record
  void _addAttendanceRecord() {
    setState(() {
      _allAttendance.add({
        "user": _userNameController.text,
        "phone": _phoneController.text,
        "checkIn": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      // clear text fields after adding record
      _userNameController.clear();
      _phoneController.clear();
    });

    // show a SnackBar to indicate successful addition of record
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white), // Tick icon
            SizedBox(width: 10), // Spacer between icon and text
            Text('Attendance record added successfully',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // form for users to add new attendance record
  void openRecordBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Attendance Record',
            style: TextStyle(fontSize: 17), textAlign: TextAlign.center),
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              _addAttendanceRecord();
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (_isEndOfListReached) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Text(
            "You have reached the end of the list!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      // Return an empty container if the end of the list is not reached
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _allAttendance.sort((a, b) =>
        DateTime.parse(b["checkIn"]).compareTo(DateTime.parse(a["checkIn"])));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text(
          "List of Attendance",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // ShowcaseView(
          //   globalKey: keyOne,
          //   title: 'Time Format',
          //   description:
          //       'Change the time format according to your preference (time ago / dd MMM yyyy, h:mm a).',
          //   child:
          // ),
          IconButton(
            icon:
                _isTimeAgoFormat ? Icon(Icons.access_time) : Icon(Icons.timer),
            tooltip: _isTimeAgoFormat
                ? 'Display in “dd MMM yyyy, h:mm a” format'
                : 'Display in time ago format',
            onPressed: () {
              setState(() {
                _isTimeAgoFormat = !_isTimeAgoFormat;
                _saveTimeFormatPreference(_isTimeAgoFormat);
              });
            },
            color: _isTimeAgoFormat ? Colors.black : Colors.white,
            hoverColor: _isTimeAgoFormat ? Colors.white : Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // ShowcaseView(
            //   globalKey: keyTwo,
            //   title: 'Search Field',
            //   description: 'Key-in any keyword to filter out the list.',
            //   child:
            // ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _foundAttendance.length + 1,
                itemBuilder: (context, index) {
                  if (index == _foundAttendance.length) {
                    return _buildFooter(); // Show the footer at the end of the list
                  }

                  String checkInText;
                  DateTime checkInDate =
                      DateTime.parse(_foundAttendance[index]["checkIn"]);
                  if (_isTimeAgoFormat) {
                    checkInText = timeago.format(checkInDate);
                  } else {
                    checkInText =
                        DateFormat('dd MMM yyyy, h:mm a').format(checkInDate);
                  }
                  return Card(
                    key: ValueKey(_foundAttendance[index]["user"]),
                    color: Colors.teal.shade100,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        _foundAttendance[index]["user"],
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      subtitle: Text(
                        "Check-in: $checkInText",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceDetail(
                              attendance: _foundAttendance[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openRecordBox();
        },
        backgroundColor: Colors.teal.shade200,
        tooltip: 'Add Attendance',
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      // ShowcaseView(
      //   globalKey: keyThree,
      //   title: 'Add Attendance Record',
      //   description:
      //       'Add new attendance record to the list by clicking this button',
      //   child:
      // ),
    );
  }
}
