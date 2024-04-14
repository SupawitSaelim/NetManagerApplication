import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'speed_database.dart';

class Speed extends StatefulWidget {
  const Speed({Key? key}) : super(key: key);

  @override
  State<Speed> createState() => _SpeedState();
}

class _SpeedState extends State<Speed> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  bool _isServerSelectionInProgress = false;

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  // Declare a variable to track if the gauge should be shown
  bool _showGauge = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      reset();
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
              'Speed Test',
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
      backgroundColor: Colors.grey[100], // Change background color to black
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_showGauge)
                  // Adding Gauge to show download and upload speeds
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        ranges: <GaugeRange>[
                          // Range for download speed
                          GaugeRange(
                              startValue: 0,
                              endValue: 100,
                              color: Colors.black), // Adjust color
                          // Range for upload speed
                          GaugeRange(
                              startValue: 0,
                              endValue: 100,
                              color: Colors.black), // Adjust color
                        ],
                        pointers: <GaugePointer>[
                          // Pointer for download progress
                          NeedlePointer(
                              value: _downloadRate,
                              enableAnimation: true,
                              needleColor: Colors.blueGrey), // Adjust color
                          // Pointer for upload progress
                          NeedlePointer(
                              value: _uploadRate,
                              enableAnimation: true,
                              needleColor: Colors.grey), // Adjust color
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                // Show download speed
                Text(
                  'Download Speed: $_downloadRate $_unitText',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey, // Change text color
                  ),
                ),
                // Show upload speed
                Text(
                  'Upload Speed: $_uploadRate $_unitText',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blueGrey, // Change text color
                  ),
                ),
                const SizedBox(height: 16.0),
                // Summary
                Text(
                  _testInProgress ? 'Testing in progress...' : 'Test completed',
                  style: TextStyle(
                      fontSize: 20.0, color: Colors.black), // Change text color
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _isServerSelectionInProgress
                    ? 'Selecting Server...'
                    : 'IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}',
                style: TextStyle(
                    fontSize: 16.0, color: Colors.black), // Change text color
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            if (!_testInProgress) ...{
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 6,
                    backgroundColor: Colors.teal[200]),
                child: const Text('Start Testing',
                    style: TextStyle(color: Colors.white,fontSize: 18.0)),
                onPressed: () async {
                  reset();
                  // Set _showGauge to true to show the gauge
                  setState(() {
                    _showGauge = true;
                  });
                  await internetSpeedTest.startTesting(
                      useFastApi: true, // Use fast.com server
                      onStarted: () {
                        setState(() => _testInProgress = true);
                      },
                      onCompleted:
                          (TestResult download, TestResult upload) async {
                        final Map<String, dynamic> speedData = {
                          'downloadRate': download.transferRate,
                          'uploadRate': upload.transferRate,
                          'timestamp': DateTime.now().toIso8601String(),
                        };
                        await SpeedDatabase.instance.insertSpeed(speedData);
                        if (kDebugMode) {
                          print(
                              'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                        }
                        setState(() {
                          _downloadRate = download.transferRate;
                          _unitText =
                              download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                          _downloadProgress = '100';
                          _downloadCompletionTime = download.durationInMillis;
                        });
                        setState(() {
                          _uploadRate = upload.transferRate;
                          _unitText =
                              upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                          _uploadProgress = '100';
                          _uploadCompletionTime = upload.durationInMillis;
                          _testInProgress = false;
                        });
                      },
                      onProgress: (double percent, TestResult data) {
                        if (kDebugMode) {
                          print(
                              'the transfer rate $data.transferRate, the percent $percent');
                        }
                        setState(() {
                          _unitText =
                              data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                          if (data.type == TestType.download) {
                            _downloadRate = data.transferRate;
                            _downloadProgress = percent.toStringAsFixed(2);
                          } else {
                            _uploadRate = data.transferRate;
                            _uploadProgress = percent.toStringAsFixed(2);
                          }
                        });
                      },
                      onError: (String errorMessage, String speedTestError) {
                        if (kDebugMode) {
                          print(
                              'the errorMessage $errorMessage, the speedTestError $speedTestError');
                        }
                        reset();
                      },
                      onDefaultServerSelectionInProgress: () {
                        setState(() {
                          _isServerSelectionInProgress = true;
                        });
                      },
                      onDefaultServerSelectionDone: (Client? client) {
                        setState(() {
                          _isServerSelectionInProgress = false;
                          _ip = client?.ip;
                          _asn = client?.asn;
                          _isp = client?.isp;
                        });
                      },
                      onDownloadComplete: (TestResult data) {
                        setState(() {
                          _downloadRate = data.transferRate;
                          _unitText =
                              data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                          _downloadCompletionTime = data.durationInMillis;
                        });
                      },
                      onUploadComplete: (TestResult data) {
                        setState(() {
                          _uploadRate = data.transferRate;
                          _unitText =
                              data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                          _uploadCompletionTime = data.durationInMillis;
                        });
                      },
                      onCancel: () {
                        reset();
                      });
                },
              )
            } else ...{
              ElevatedButton(
                // Change to ElevatedButton
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 6,
                    backgroundColor: Colors.red),
                onPressed: () =>
                    internetSpeedTest.cancelTest(), // Cancel the test
                child: const Text('Cancel Test',
                    style: TextStyle(color: Colors.white,fontSize: 20.0)), // Set button text
              ),
            },
          ],
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      {
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _downloadProgress = '0';
        _uploadProgress = '0';
        _unitText = 'Mbps';
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;

        _ip = null;
        _asn = null;
        _isp = null;

        // Hide the gauge when resetting
        _showGauge = false;
      }
    });
  }
}
