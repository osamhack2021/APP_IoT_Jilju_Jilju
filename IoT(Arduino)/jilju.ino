/*
  Jilju, soldier running history management system
  Copyright (C) 2021  Jilju

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/*
  Arduino_MKRGPS 1.0.0
  https://github.com/arduino-libraries/Arduino_MKRGPS
*/
#include <Arduino_MKRGPS.h>
/*
  ArduinoBLE 1.2.1
  https://github.com/arduino-libraries/ArduinoBLE
*/
#include <ArduinoBLE.h>

#include <SPI.h>
#include <SD.h>

#define GPS_PIN         (4)
#define BLE_PIN         (2)
#define SWITCH_PIN      (3)
#define GPS_MODE        (1)
#define BLE_MODE        (0)
#define BUF_LEN         (20)
#define MAX_FILE_ID     (9999999)

int mode = BLE_MODE;
String fileName;
unsigned long initialTime, lastTime;
float initialLatitude;
float initialLongitude;

BLEService ftpService("1819");
BLECharacteristic fileIdChar("2AC3", BLEWrite, sizeof(int32_t));
BLECharacteristic fileDataChar("2A67", BLERead | BLEIndicate, BUF_LEN);
uint8_t buf[BUF_LEN];
bool bleAuthenticated;

String getNextFileName() {
  int32_t lo = 0;
  int32_t hi = 10000000;
  while (lo + 1 < hi) {
    int32_t mid = (lo + hi) / 2;
    if (SD.exists(String(mid) + ".csv")) {
      lo = mid;
    } else {
      hi = mid;
    }
  }
  return String(hi) + ".csv";
}

void logInitialTime() {
  File file = SD.open(fileName, FILE_WRITE);
  file.println(initialTime);
  file.close();
}

void logLocation(unsigned long time, float latitude, float longitude) {
  String log = "";
  log += (time - initialTime);
  log += ',';
  log += (int32_t) (100000 * (latitude - initialLatitude));
  log += ',';
  log += (int32_t) (100000 * (longitude - initialLongitude));
  log += '\n';
  File file = SD.open(fileName, FILE_WRITE);
  file.print(log);
  file.close();
}

int32_t readFileId() {
  const uint8_t* val = fileIdChar.value();
  int32_t fileId = 0;
  for (int i = 0; i < sizeof(int); i++) {
    fileId |= val[i] << (i << 3);
  }
  return fileId;
}

void transferFile(int32_t fileId) {
  String fileName = String(fileId) + ".csv";
  fileDataChar.writeValue((uint8_t) '^');
  if (bleAuthenticated && SD.exists(fileName)) {
    File file = SD.open(fileName, FILE_READ);
    while (file.available()) {
      int len = file.read(buf, BUF_LEN);
      fileDataChar.writeValue(buf, len);
    }
    file.close();
  }
  fileDataChar.writeValue((uint8_t) '$');
}

void blinkLed(unsigned int count, unsigned long delayTime) {
  while (count--) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(delayTime);
    digitalWrite(LED_BUILTIN, LOW);
    delay(delayTime);
  }
}

void pinSetup() {
  pinMode(GPS_PIN, INPUT_PULLUP);
  pinMode(BLE_PIN, INPUT_PULLUP);
  pinMode(SWITCH_PIN, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(SWITCH_PIN, LOW);
  digitalWrite(LED_BUILTIN, LOW);
}

int gpsBegin() {
  if (!GPS.begin()) {
    blinkLed(5, 500);
    return 0;
  }
  digitalWrite(LED_BUILTIN, LOW);
  fileName = getNextFileName();
  GPS.available();
  while (!GPS.available() && !isModeChanged());
  if (isModeChanged()) {
    return 0;
  }
  initialTime = lastTime = GPS.getTime();
  initialLatitude = GPS.latitude();
  initialLongitude = GPS.longitude();
  logInitialTime();
  digitalWrite(LED_BUILTIN, HIGH);
  return 1;
}

void gpsLoop() {
  if (GPS.available() && (GPS.getTime() - lastTime) >= 10) {
    logLocation(lastTime = GPS.getTime(), GPS.latitude(), GPS.longitude());
  }
}

void gpsEnd() {
  GPS.end();
  digitalWrite(LED_BUILTIN, LOW);
}

void bleSetup() {
  ftpService.addCharacteristic(fileIdChar);
  ftpService.addCharacteristic(fileDataChar);
}

int bleBegin() {
  if (!BLE.begin()) {
    blinkLed(5, 500);
    return 0;
  }
  BLE.setLocalName("Jilju");
  BLE.setAdvertisedService(ftpService);
  BLE.addService(ftpService);
  BLE.advertise();
  return 1;
}

void bleLoop() {
  BLEDevice central = BLE.central();
  if (central && central.connected() && fileIdChar.written()) {
    int32_t fileId = readFileId();
    if (fileId <= MAX_FILE_ID) {
      transferFile(fileId);
    } else {
      String fileName = String(fileId) + ".pwd";
      bleAuthenticated = SD.exists(fileName);
    }
  }
}

void bleEnd() {
  bleAuthenticated = false;
  BLE.end();
}

int isModeChanged() {
  int gps = digitalRead(GPS_PIN);
  int ble = digitalRead(BLE_PIN);
  return gps != ble && mode != gps;
}

void checkMode() {
  if (!isModeChanged()) {
    return;
  }
  blinkLed(5, 100);
  if (mode == GPS_MODE) {
    gpsEnd();
    mode = BLE_MODE;
    bleBegin();
  } else if (mode == BLE_MODE) {
    bleEnd();
    mode = GPS_MODE;
    gpsBegin();
  }
}

void setup() {
  pinSetup();
  if (!SD.begin()) {
    blinkLed(5, 500);
  }
  bleSetup();
  bleBegin();
  blinkLed(5, 100);
}

void loop() {
  checkMode();
  if (mode == GPS_MODE) {
    gpsLoop();
  } else if (mode == BLE_MODE) {
    bleLoop();
  }
}
