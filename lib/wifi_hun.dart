import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class WiFiHun extends StatefulWidget {
  const WiFiHun({Key? key}) : super(key: key);

  @override
  State<WiFiHun> createState() => _WiFiHunState();
}

class _WiFiHunState extends State<WiFiHun> {
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  Color huntButtonColor = Colors.lightBlue;
  bool isScanning = false;

  Future<void> huntWiFis() async {
    setState(() {
      huntButtonColor = Colors.red;
      isScanning = true;
    });

    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      huntButtonColor = Colors.lightBlue;
      isScanning = false;
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
              'WiFi Hunter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    setState(() => wiFiHunterResult.results.clear()),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: isScanning ? null : huntWiFis,
                  child: isScanning
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Scan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
              ),
              SizedBox(height: 10.0),
              wiFiHunterResult.results.isNotEmpty
                  ? Column(
                      children: wiFiHunterResult.results.map((result) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            leading: Text('${result.level} dbm'),
                            title: Text(result.ssid),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('BSSID : ${result.bssid}'),
                                Text('Capabilities : ${result.capabilities}'),
                                Text('Frequency : ${result.frequency}'),
                                Text('Channel Width : ${result.channelWidth}'),
                                Text('Timestamp : ${result.timestamp}'),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Container(),
              SizedBox(height: 20.0),
              Image.asset(
                'assets/images/1.png',
                width: 150.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
