import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';

class pingios extends StatefulWidget {
  const pingios({Key? key}) : super(key: key);

  @override
  State<pingios> createState() => _pingiosState();
}

class _pingiosState extends State<pingios> {
  List<PingData> _pingDataList = [];
  final TextEditingController _ipController =
      TextEditingController(text: 'google.com');

  void _startPing() {
    final ping = Ping(_ipController.text, count: 5);
    print('Running command: ${ping.command}');
    ping.stream.listen((event) {
      setState(() {
        _pingDataList.add(event);
      });
    });
  }

  void _clearPingData() {
    setState(() {
      _pingDataList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: AppBar(
            title: Text(
              'Ping',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.transparent, // Make the app bar transparent
            elevation: 0, // Remove the shadow
            centerTitle: true, // Center the title
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: _clearPingData,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _ipController.text = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter IP Address',
                  icon: Icon(Icons.computer_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startPing,
                child: Text(
                  'Start',
                  style: TextStyle(color: Colors.white,fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  elevation: 6,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _pingDataList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      padding: EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(checksum(index)),
                              subtitle: Text(_pingDataList[index].toString()),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String checksum(index) {
  if (index == 5 || index == 11 || index == 17 || index == 23 || index == 29) {
    return "ICMP Summary";
  } else {
    return "ICMP ${index + 1}";
  }
}
