import 'package:flutter/material.dart';
import 'package:whois/whois.dart';

class WhoisLookup extends StatefulWidget {
  const WhoisLookup({Key? key}) : super(key: key);

  @override
  _WhoisLookupState createState() => _WhoisLookupState();
}

class _WhoisLookupState extends State<WhoisLookup> {
  Map<String, dynamic> _whoisData = {}; // Adjusted type to dynamic
  final TextEditingController _domainController =
      TextEditingController(text: 'facebook.com');

  void _startWhoisLookup() async {
    final domain = _domainController.text;
    var options = const LookupOptions(
      timeout: Duration(milliseconds: 10000),
      port: 43,
    );

    try {
      final whoisResponse = await Whois.lookup(domain, options);
      final parsedResponse = Whois.formatLookup(whoisResponse);

      setState(() {
        _whoisData = parsedResponse;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _clearWhoisData() {
    setState(() {
      _whoisData.clear();
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
              'WHOIS Lookup',
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
                onPressed: _clearWhoisData,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _domainController,
                  onChanged: (value) {
                    setState(() {
                      _domainController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Domain Name',
                    icon: Icon(Icons.domain),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _startWhoisLookup,
                  child: Text(
                    'Lookup',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[200],
                  elevation: 6,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                ),
                SizedBox(height: 25),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _whoisData.length,
                  itemBuilder: (context, index) {
                    final key = _whoisData.keys.elementAt(index);
                    final value = _whoisData[key];
                    return Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            value.toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
