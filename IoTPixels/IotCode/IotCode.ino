const int LED_PIN = 2; // GPIO2 is the built-in LED pin on ESP01

void setup() {
    pinMode(LED_PIN, OUTPUT);
}

void loop() {
    digitalWrite(LED_PIN, HIGH); // Turn on the LED
    delay(1000); // Wait for 1 second
    digitalWrite(LED_PIN, LOW); // Turn off the LED
    delay(1000); // Wait for 1 second
}