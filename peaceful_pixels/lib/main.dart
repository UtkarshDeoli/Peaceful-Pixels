import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('broker.hivemq.com', '1883');
void main() async {
  runApp(MyApp(client: client));
  client.logging(on: true);
  client.keepAlivePeriod = 60;
  client.onConnected = onConnected;
  makeConnection();
}

Future<bool> makeConnection() async {
  bool toReturn = false;
  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
  }
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('client connected');
    toReturn = true;
  } else {
    print(
        'client connection failed - disconnecting, status is ${client.connectionStatus}');
    toReturn = false;
    client.disconnect();
  }
  return toReturn;
}

void onConnected() {
  const pubTopic = 'test/utkarsh/india/LedState';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
}

void sendMessage(String ans) {
  const pubTopic = 'test/utkarsh/india/LedState';
  final builder = MqttClientPayloadBuilder();
  builder.addString(ans);
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
}

class MyApp extends StatelessWidget {
  final MqttServerClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String ans = "";
  void giveSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      appBar: AppBar(
        title: const Text(
          "Peaceful Pixels",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(333),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 50),
            child: TextField(
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w200),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: "Message",
                  hintText: 'Enter the Custom Message You Wanna Send',
                  hintStyle: const TextStyle(color: Colors.white38),
                  suffix: IconButton(
                      onPressed: () {
                        sendMessage(ans);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Custom Message Sent !')));
                      },
                      icon: const Icon(Icons.send))),
              onChanged: (value) {
                // Update the ans variable when the text changes
                setState(() {
                  ans = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: const Text("Re-Connect"),
            onPressed: () async {
              Future<bool> ans = makeConnection();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Making Connection'),
                ),
              );
              if (await ans) {
                giveSnackBar(const SnackBar(content: Text("Connected!")));
              } else {
                giveSnackBar(const SnackBar(content: Text("Can't Connected!")));
              }
            },
          ),
          const SizedBox(
            height: 50,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      sendMessage("I Love You");
                      final snackBar =
                          SnackBar(content: Text('Message Sent !'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.teal,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 60,
                            color: Colors.red,
                          ),
                          Text(
                            "Press To Send Love",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //second one
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      sendMessage("FUCK U");
                      final snackBar =
                          SnackBar(content: Text('Message Sent !'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.redAccent,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notification_important_sharp,
                            size: 60,
                            color: Colors.yellow,
                          ),
                          Text(
                            "Emergency",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      sendMessage("Miss You");
                      final snackBar =
                          SnackBar(content: Text('Message Sent !'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.pink,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sms,
                            size: 60,
                            color: Color.fromARGB(255, 131, 189, 255),
                          ),
                          Text(
                            "Miss You",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      sendMessage("Come When You Have Time");
                      final snackBar = SnackBar(
                        content: Text('Message Sent !'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.redAccent,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 60,
                            color: Colors.yellow,
                          ),
                          Text(
                            "Come Soon",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
