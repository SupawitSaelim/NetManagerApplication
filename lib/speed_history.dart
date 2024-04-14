import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'speed_database.dart';

class SpeedHistoryPage extends StatelessWidget {
  const SpeedHistoryPage({Key? key}) : super(key: key);

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
              'Speed Test Histories',
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
                onPressed: () => _deleteSpeedTestHistory(context),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: SpeedDatabase.instance.queryAllSpeeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final speeds = snapshot.data!;
            return speeds.isEmpty
                ? Center(child: Text('No speed test history available'))
                : ListView.builder(
                    itemCount: speeds.length,
                    itemBuilder: (context, index) {
                      final speed = speeds[index];
                      final timestamp = speed['timestamp'] as String;
                      final formattedTimestamp = _formatTimestamp(timestamp);
                      final downloadRate = speed['downloadRate'];
                      final uploadRate = speed['uploadRate'];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(2.0),
                        child: ListTile(
                          title: Text(formattedTimestamp),
                          subtitle: Text(
                              'Download: ${downloadRate.toStringAsFixed(2)} Mbps, Upload: ${uploadRate.toStringAsFixed(2)} Mbps'),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    final parsedTimestamp = DateTime.parse(timestamp);
    final formatter = DateFormat('dd MMMM yyyy, HH:mm', 'en');
    return formatter.format(parsedTimestamp);
  }

  void _deleteSpeedTestHistory(BuildContext context) async {
  await SpeedDatabase.instance.deleteAllSpeeds();
  // Trigger a rebuild of the widget tree
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => SpeedHistoryPage()),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Speed test history deleted'),
      duration: Duration(seconds: 1),
    ),
  );
}
}
