import 'dart:io';
import 'package:dart_snmp/dart_snmp.dart';
import 'package:flutter/material.dart';

class Mibbasic extends StatefulWidget {
  const Mibbasic({Key? key});

  @override
  State<Mibbasic> createState() => _MibbasicState();
}

class _MibbasicState extends State<Mibbasic> {
  late TextEditingController _ipController;
  late TextEditingController _communityController;
  Map<String, String> snmpData = {};

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _fetchSnmpData() async {
    try {
      var target = InternetAddress(_ipController.text.trim());
      var session = await Snmp.createSession(target);

      var oids = {
        'System Name': '1.3.6.1.2.1.1.5.0', // sysName
        'System Description': '1.3.6.1.2.1.1.1.0', // sysDesc
        'System Uptime': '1.3.6.1.2.1.1.3.0', // sysUpTime
        'System Location': '1.3.6.1.2.1.1.6.0', //syslocation
        'System Contact': '1.3.6.1.2.1.1.4.0', // sysContact
      };

      Map<String, String> tempData = {};
      for (var title in oids.keys) {
        var oid = Oid.fromString(oids[title]!);
        var message = await session.get(oid);
        var value = message.pdu.varbinds[0].value.toString();
        if (title == 'System Uptime') {
          value = _parseSystemUptime(value);
        }
        tempData[title] = value;
      }

      setState(() {
        snmpData = tempData;
      });
    } catch (e) {
      setState(() {
        snmpData = {'Error fetching SNMP data': '$e'};
      });
    }
  }

  String _parseSystemUptime(String value) {
    try {
      var parts = value.split(':');
      if (parts.length != 3) {
        return 'Invalid uptime format';
      }

      var hours = int.parse(parts[0]);
      var minutes = int.parse(parts[1]);
      var seconds = int.parse(parts[2].split('.')[0]);

      return '$hours hours $minutes minutes $seconds seconds';
    } catch (e) {
      return 'Invalid uptime format';
    }
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
              'MIB ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.transparent, // Make the app bar transparent
            elevation: 0, // Remove the shadow
            centerTitle: true, // Center the title
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _ipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: 'IP Address',
                  icon: Icon(Icons.computer_rounded),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchSnmpData,
                child: Text(
                  'Fetch SNMP Data',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  elevation: 6,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: snmpData.length,
                itemBuilder: (BuildContext context, int index) {
                  var title = snmpData.keys.elementAt(index);
                  var value = snmpData[title];
                  return ListTile(
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(value ?? ''),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
