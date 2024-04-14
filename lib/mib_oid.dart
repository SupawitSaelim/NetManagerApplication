import 'dart:io';
import 'package:dart_snmp/dart_snmp.dart';
import 'package:flutter/material.dart';

class Miboid extends StatefulWidget {
  const Miboid({Key? key}) : super(key: key);

  @override
  State<Miboid> createState() => _MiboidState();
}

class _MiboidState extends State<Miboid> {
  late TextEditingController _ipController;
  late TextEditingController _oidController;
  Map<String, String> snmpData = {};

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _oidController = TextEditingController();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _oidController.dispose();
    super.dispose();
  }

  Future<void> _fetchSnmpData() async {
    try {
      var target = InternetAddress(_ipController.text.trim());
      var session = await Snmp.createSession(target);

      var oid = Oid.fromString(_oidController.text.trim());
      var message = await session.get(oid);
      var value = message.pdu.varbinds[0].value.toString();

      setState(() {
        snmpData = {'OID Value': value};
      });
    } catch (e) {
      setState(() {
        snmpData = {'Error fetching SNMP data': '$e'};
      });
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
              'MIB OID ',
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
                  labelStyle: TextStyle(color: Colors.black, letterSpacing: 2),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _oidController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: 'OID',
                  icon: Icon(Icons.format_list_numbered_rtl_rounded),
                  labelStyle: TextStyle(color: Colors.black, letterSpacing: 2),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchSnmpData,
                child: Text(
                  'Fetch SNMP Data',
                  style: TextStyle(color: Colors.white,fontSize: 16),
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
