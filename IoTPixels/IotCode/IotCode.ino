#include <ESP8266WiFi.h> 
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "secreats.h"

#define MAX_MSG_LEN (128)
#define buzzer 3
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels
#define OLED_RESET     -1 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

int x=0;
const char* ssid = _ssid;
const char* password = _password;
const char *serverHostname = _serverHostname;
const char *topic = _topic;
//const IPAddress serverIPAddress(192, 168, 1, 9);

WiFiClient espClient;
PubSubClient client(espClient);


void setup() {
  // Configure serial port for debugging
  Serial.begin(9600);
  Wire.begin(2, 0); 
  display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS);
  // initialize with the I2C addr 0x3D (for the 128x64)
  // Initialise wifi connection - this will wait until connected
  connectWifi();
  // connect to MQTT server  
  client.setServer(serverHostname, 1883);
  client.setCallback(callback);
  display.display();
  delay(2000);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0,0);
  pinMode(buzzer,OUTPUT);
}

void loop() {
    if (!client.connected()) {
      connectMQTT();
    }
    // this is ESSENTIAL!
    client.loop();
    // idle
    delay(500);
}

void connectWifi() {
  delay(10);
  // Connecting to a WiFi network
  Serial.printf("\nConnecting to %s\n", ssid);
  display.println("Connecting....");
  display.display();
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(250);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("WiFi connected on IP address ");
  display.println("Connected:) IP:");
  display.println(WiFi.localIP());
  Serial.println(WiFi.localIP());
}

// connect to MQTT server
void connectMQTT() {
  // Wait until we're connected
  while (!client.connected()) {
    // Create a random client ID
    String clientId = "ESP8266-";
    clientId += String(random(0xffff), HEX);
    Serial.printf("MQTT connecting as client %s...\n", clientId.c_str());
    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.println("MQTT connected");
      display.println("MQTT connected");
      display.display();
      digitalWrite(buzzer,HIGH);
      delay(1000);
      digitalWrite(buzzer,LOW);
      delay(1000);
      display.clearDisplay();
      // Once connected, publish an announcement...
      client.publish(topic, "Device is Connected");
      // ... and resubscribe
      client.subscribe(topic);
    } else {
      Serial.printf("MQTT failed, state %s, retrying...\n", client.state());
      // Wait before retrying
      delay(2500);
    }
  }
}

void callback(char *msgTopic, byte *msgPayload, unsigned int msgLength){
  // copy payload to a static string
  static char message[MAX_MSG_LEN+1];
  if (msgLength > MAX_MSG_LEN) {
    msgLength = MAX_MSG_LEN;
  }
  strncpy(message, (char *)msgPayload, msgLength);
  message[msgLength] = '\0';
  if(x>=6)
  {
    x=0;
    display.clearDisplay();
  }
  display.setCursor(0,10*x);
  x++;
  display.println(message);
  display.display();
  Serial.printf("topic %s, message received: %s\n", topic, message);
  digitalWrite(buzzer,HIGH);
  delay(100);
  digitalWrite(buzzer,LOW);
  if (strcmp(message, "FUCK U") == 0) {
    fuckMe();
  }
  }


void fuckMe()
{
  for(int i=0;i<10;i++)
  {
    digitalWrite(buzzer,HIGH);
    delay(500);
    digitalWrite(buzzer,LOW);
  }
  }
