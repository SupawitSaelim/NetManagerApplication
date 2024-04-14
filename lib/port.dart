import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: PortScannerWidget(),
  ));
}

class PortScannerWidget extends StatefulWidget {
  const PortScannerWidget({Key? key});

  @override
  State<PortScannerWidget> createState() => _PortScannerWidgetState();
}

class _PortScannerWidgetState extends State<PortScannerWidget> {
  String host = '';
  List<Map<String, dynamic>> ports = [
    {'name': 'echo', 'port': 7},
    {'name': 'ftp-data', 'port': 20},
    {'name': 'FTP', 'port': 21},
    {'name': 'SSH', 'port': 22},
    {'name': 'Telnet', 'port': 23},
    {'name': 'SMTP', 'port': 25},
    {'name': 'DNS', 'port': 53},
    {'name': 'DHCP', 'port': 67},
    {'name': 'DHCP', 'port': 68},
    {'name': 'TFTP', 'port': 69},
    {'name': 'Finger', 'port': 79},
    {'name': 'HTTP', 'port': 80},
    {'name': 'kerberos', 'port': 88},
    {'name': 'POP3', 'port': 110},
    {'name': 'IMAP', 'port': 143},
    {'name': 'HTTPS', 'port': 443},
    {'name': 'SMB', 'port': 445},
    {'name': 'SMTP Alt', 'port': 587},
    {'name': 'IMAP Alt', 'port': 993},
    {'name': 'POP3 Alt', 'port': 995},
    {'name': 'HTTP proxy', 'port': 8080},
    {'name': 'SFTP', 'port': 115},
    {'name': 'LDAP', 'port': 389},
    {'name': 'LDAPS', 'port': 636},
    {'name': 'MYSQL', 'port': 3306},
    {'name': 'RDP', 'port': 3389},
    {'name': 'VNC', 'port': 5900},
    {'name': 'MSSQL', 'port': 1433},
    {'name': 'FTP Alt', 'port': 2121},
    {'name': 'Telnet Alt', 'port': 992},
    {'name': 'DNS Alt', 'port': 1153},
    {'name': 'SNMP', 'port': 161},
    {'name': 'SNMP Trap', 'port': 162},
    {'name': 'NTP', 'port': 123},
    {'name': 'Syslog', 'port': 514},
    {'name': 'DHCP Server', 'port': 67},
    {'name': 'DHCP Client', 'port': 68},
    {'name': 'TFTP', 'port': 69},
    {'name': 'Remote Job Entry', 'port': 77},
    {'name': 'CTF', 'port': 81},
    {'name': 'HTTP', 'port': 591},
    {'name': 'HTTP', 'port': 593},
    {'name': 'HTTP', 'port': 631},
    {'name': 'UDP', 'port': 1194},
    {'name': 'SIP', 'port': 5060},
    {'name': 'SIP', 'port': 5061},
    {'name': 'RTSP', 'port': 554},
    {'name': 'LLMNR', 'port': 5355},
    {'name': 'HCP', 'port': 5985},
    {'name': 'HCP', 'port': 5986},
    {'name': 'SSDP', 'port': 1900},
    {'name': 'Socks', 'port': 1080},
    {'name': 'BACNET', 'port': 47808},
    {'name': 'CAP', 'port': 47809},
    {'name': 'NBSS', 'port': 139},
    {'name': 'IMAP', 'port': 220},
    {'name': 'NNTP', 'port': 119},
    {'name': 'NFS', 'port': 111},
    {'name': 'BGP', 'port': 179},
    {'name': 'NNTP', 'port': 563},
    {'name': 'SNTP', 'port': 123},
    {'name': 'Socks', 'port': 1080},
    {'name': 'XDMCP', 'port': 177},
    {'name': 'VNC', 'port': 5901},
    {'name': 'HTTP', 'port': 5988},
    {'name': 'HTTP', 'port': 5989},
    {'name': 'CIM', 'port': 5989},
    {'name': 'XMPP', 'port': 5222},
    {'name': 'XMPP', 'port': 5223},
    {'name': 'XMPP', 'port': 5269},
    {'name': 'XMPP', 'port': 5280},
    {'name': 'Socks', 'port': 1081},
    {'name': 'VNC', 'port': 5902},
    {'name': 'Syslog', 'port': 514}
  ];
  List<int> openPorts = [];
  TextEditingController ipController = TextEditingController();
  bool scanning = false;

  void scanPorts() async {
    openPorts.clear();
    setState(() {
      scanning = true;
    });

    for (Map<String, dynamic> portInfo in ports) {
      bool isOpen = await checkPort(host, portInfo['port']);
      if (isOpen) {
        openPorts.add(portInfo['port']);
        setState(() {});
      }
    }

    setState(() {
      scanning = false;
    });
  }

  Future<bool> checkPort(String host, int port) async {
    try {
      var socket =
          await Socket.connect(host, port, timeout: Duration(seconds: 2));
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  void resetPorts() {
    openPorts.clear();
    setState(() {});
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
              'Port Scanner',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: 'IP Address:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                icon: Icon(Icons.computer_rounded),
              ),
              onChanged: (value) {
                setState(() {
                  host = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: scanning ? null : scanPorts,
                  child: Row(
                    children: [
                      Text(
                        'Scan Ports',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      if (scanning)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[200],
                    elevation: 6,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (openPorts.isNotEmpty)
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 300, // Adjust height as needed
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Port')),
                          DataColumn(label: Text('Service')),
                        ],
                        rows: openPorts.map((port) {
                          Map<String, dynamic> portInfo = ports
                              .firstWhere((element) => element['port'] == port);
                          String portName = portInfo['name'] ?? 'Port $port';
                          return DataRow(cells: [
                            DataCell(Text('$port')),
                            DataCell(Text(portName)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            if (!scanning && openPorts.isEmpty)
              Center(
                child: Text(
                  '',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
