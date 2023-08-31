import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectbncc/screens/login_screen.dart';
import 'package:projectbncc/screens/pay_screen.dart';
import 'package:projectbncc/screens/profile_screen.dart';
import 'package:projectbncc/screens/topUp_screen.dart';

import '../services/auth_service.dart';

String formatCurrency(double amount) {
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
  return formatCurrency.format(amount);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: users.doc(currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    String username = snapshot.data?['username'] ?? '';
                    return Text(
                      "Hi, $username",
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    );
                  },
                )
              ],
            ),
            IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await AuthService().logout();
              navigator.push(
                MaterialPageRoute(builder: (context) => const LoginScreen())
              );
            },
          ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Center(
              child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 150,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/backgroundSaldo.jpg'),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(
                  Radius.circular(18.0)),
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: users.doc(currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                double balance = snapshot.data?['balance'] ?? 0.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Saldo Kamu",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Rp. ${formatCurrency(balance)}",
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
          const SizedBox(height: 16),
          feature()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {
                  //hanya untuk keperluan desain agar rapi dengan 3 icon
                },
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feature() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // Tindakan yang ingin Anda lakukan saat tombol "Top Up" ditekan
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TopUpScreen(),
                        ),
                      );
                    },
                    icon: Image.asset(
                      "assets/images/topUp.png",
                      width: 45,
                    ),
                  ),
                  const Text("Top Up")
                ],
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PayScreen()
                          )
                        );
                      },
                      icon: Image.asset(
                        "assets/images/pay.png",
                        width: 50,
                      )),
                  const Text("Pay")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
