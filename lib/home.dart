import 'package:flutter/material.dart';
import 'package:whois/whois.dart';
import 'speedtest.dart';
import 'mibbasic.dart';
import 'mib_oid.dart';
import 'ping.dart';
import 'speed_database.dart';
import 'speed_history.dart';
import 'whois.dart';
import 'port.dart';
import 'wifi_hun.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 90.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Row(
              // Wrap text and image in a row
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'NetManager',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 25.0),
                Icon(
                  Icons.computer_outlined,
                  color: Colors.grey[100],
                  size: 40.0,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      _buildIconButton(
                        icon: Icons.speed,
                        label: 'Speed Test',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Speed();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                      SizedBox(width: 30),
                      _buildIconButton(
                        icon: Icons.view_list,
                        label: 'MIB-Basic',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Mibbasic();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      _buildIconButton(
                        icon: Icons.device_hub,
                        label: 'MIB-BY-OID',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Miboid();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                      SizedBox(width: 30),
                      _buildIconButton(
                        icon: Icons.network_check,
                        label: 'Ping',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return pingios();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      _buildIconButton(
                        icon: Icons.podcasts,
                        label: 'Port Scanning',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PortScannerWidget();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                      SizedBox(width: 30),
                      _buildIconButton(
                        icon: Icons.where_to_vote_sharp,
                        label: 'Whois',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WhoisLookup();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      _buildIconButton(
                        icon: Icons.history_rounded,
                        label: 'Speed test ' + '\n  histories',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SpeedHistoryPage();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                      SizedBox(width: 30),
                      _buildIconButton(
                        icon: Icons.wifi_sharp,
                        label: 'WiFi Scanner',
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WiFiHun();
                          }));
                        },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color buttonColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 70,
              color: iconColor,
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
