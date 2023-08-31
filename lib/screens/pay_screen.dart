import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Transfer Berhasil"),
          content: const Text("Transfer sudah berhasil"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar("Authentication Failed");
      return;
    }

    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    final userData = await userDoc.get();
    final currentBalance = userData["balance"] ?? 0;

    final amount = int.tryParse(_amountController.text) ?? 0;
    final targetUsername = _usernameController.text;

    final targetUserQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: targetUsername)
        .get();

    if (targetUserQuery.size != 1) {
      _showSnackBar("Target user not found");
      return;
    }

    final targetUserData = targetUserQuery.docs.first;
    final targetUserId = targetUserData.id;

    final targetUserDoc =
        FirebaseFirestore.instance.collection("users").doc(targetUserId);
    final targetUserBalance = targetUserData["balance"] ?? 0;

    final newTargetUserBalance = targetUserBalance + amount;
    final newCurrentBalance = currentBalance - amount;

    // Update saldo pada Firebase
    await userDoc.update({"balance": newCurrentBalance});
    await targetUserDoc.update({"balance": newTargetUserBalance});

    _showSuccessDialog();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pay",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Jumlah Saldo (Rp)",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.attach_money),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 134, 90, 254)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username Tujuan",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.person),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 134, 90, 254)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                await _pay();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 134, 90, 254),
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 60.0,
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
