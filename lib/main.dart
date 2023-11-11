
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController prime1Controller = TextEditingController();
  TextEditingController prime2Controller = TextEditingController();
  String encryptedMessage = "";
  
  String decryptedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RSA Encryption and Decryption"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget><Widget>[
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: "Enter your message"),

            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: prime1Controller,
                    decoration: const InputDecoration(labelText: "Enter Prime 1"),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: prime2Controller,
                    decoration: const InputDecoration(labelText: "Enter Prime 2"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: encryptMessage,
              child: const Text("Encrypt"),
            ),
            const SizedBox(height: 16.0),
            Text("Encrypted Message: $encryptedMessage"),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: decryptMessage,
              child: const Text("Decrypt"),
            ),
            const SizedBox(height: 16.0),
             Text("Decrypted Message: $decryptedMessage"),

          ],
        ),
      ),
    );
  }

  void encryptMessage() {
    String message = messageController.text;
    int prime1 = int.parse(prime1Controller.text);
    int prime2 = int.parse(prime2Controller.text);

    int n = prime1 * prime2;
    int phi = (prime1 - 1) * (prime2 - 1);
    int e = calculateE(phi);
    int d = calculateD(e, phi);

    String encrypted = rsaEncrypt(message, e, n);

    setState(() {
      encryptedMessage = encrypted;
    });
  }

  void decryptMessage() {
    String encrypted = encryptedMessage;
    int prime1 = int.parse(prime1Controller.text);
    int prime2 = int.parse(prime2Controller.text);

    int n = prime1 * prime2;
    int phi = (prime1 - 1) * (prime2 - 1);
    int e = calculateE(phi);
    int d = calculateD(e, phi);

    String decrypted = rsaDecrypt(encrypted, d, n);

    setState(() {
      decryptedMessage = decrypted;
    });
  }

  int calculateE(int phi) {
    int e = 2;
    while (e < phi) {
      if (gcd(e, phi) == 1) {
        return e;
      }
      e++;
    }
    return 0;
  }

  int calculateD(int e, int phi) {
    int d = 2;
    while ((d * e) % phi != 1) {
      d++;
    }
    return d;
  }

  int gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return gcd(b, a % b);
  }

  String rsaEncrypt(String message, int e, int n) {
    String encrypted = "";
    for (int i = 0; i < message.length; i++) {
      int charCode = message.codeUnitAt(i);
      int encryptedCharCode = modPow(charCode, e, n);
      encrypted += String.fromCharCode(encryptedCharCode);
    }
    return encrypted;
  }

  String rsaDecrypt(String encrypted, int d, int n) {
    String decrypted = "";
    for (int i = 0; i < encrypted.length; i++) {
      int charCode = encrypted.codeUnitAt(i);
      int decryptedCharCode = modPow(charCode, d, n);
      decrypted += String.fromCharCode(decryptedCharCode);
    }
    return decrypted;
  }

  int modPow(int base, int exponent, int modulus) {
    if (exponent == 0) {
      return 1;
    }
    int result = 1;
    base = base % modulus;
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % modulus;
      }
      exponent = exponent >> 1;
      base = (base * base) % modulus;
    }
    return result;
  }
}

