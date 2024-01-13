void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(analogRead(A0)*(5.0 / 1023.0));
  delay(200);  // delay between reads
}
