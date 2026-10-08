import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  bool isLoading = false;
  String result = "";
  String errorMessage = "";

  Future<void> fetchPrediction() async {
    setState(() {
      isLoading = true;
      result = "";
      errorMessage = "";
    });

    try {
      // PENTING: Ganti 192.168.x.x dengan alamat IPv4 laptop kamu!
      final response = await http.post(
        Uri.parse('http://192.168.1.8:8000/api/v1/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"feature_1": 15.0, "feature_2": "test"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result =
              "Hasil: ${data['prediction_result']}\nSkor: ${data['confidence_score']}";
        });
      } else {
        setState(() {
          errorMessage =
              "Error: Server mengembalikan status ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error Koneksi: Gagal terhubung ke server.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mini-Project ML')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),

            if (result.isNotEmpty)
              Text(
                result,
                style: TextStyle(color: Colors.green, fontSize: 18),
                textAlign: TextAlign.center,
              ),

            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : fetchPrediction,
              child: Text('Kirim Prediksi'),
            ),
          ],
        ),
      ),
    );
  }
}
