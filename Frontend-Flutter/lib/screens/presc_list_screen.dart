import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/user_model.dart';
import 'package:medicineapp/screens/login_screen.dart';
import 'package:medicineapp/ui_consts.dart';
import 'package:medicineapp/services/api_services.dart';
import 'package:medicineapp/widgets/prescription_widget.dart';

class PrescListScreen extends StatefulWidget {
  final int uid;
  Function func;

  PrescListScreen({
    super.key,
    required this.uid,
    required this.func,
  });

  @override
  State<PrescListScreen> createState() => _PrescListScreenState();
}

class _PrescListScreenState extends State<PrescListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2fe),
      appBar: AppBar(
        title: PrescListScreenAppBarWidget(
          onRefresh: () {
            setState(() {});
          },
          func: widget.func,
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
        elevation: 5,
        shadowColor: Colors.grey[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                apiService.pingServer(),
                apiService.getPrescList(widget.uid),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  if (snapshot.data != null) {
                    if (snapshot.data![0] != 204) {
                      return const Center(
                        child: Text('Server status error'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data![1].length,
                        itemBuilder: (context, index) {
                          return PrescWidget(
                            index: index,
                            uid: widget.uid,
                            prescId: snapshot.data![1].prescIdList[
                                snapshot.data![1].length - index - 1],
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PrescListScreenAppBarWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  final Function func;

  const PrescListScreenAppBarWidget({
    super.key,
    required this.onRefresh,
    required this.func,
  });

  void handleLogout(BuildContext context) {
    // Call your logout function here, for example:
    // await AuthService().logout();

    // Reset the tab controller
    // tabController.index = 0;
    func();

    // Clear the navigation stack and navigate to the LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      // (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        // vertical: 40,
        left: 12,
        right: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/logos/MM_logo_white.png',
            width: 110,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    onRefresh();
                  },
                  icon:
                      const Icon(Icons.refresh, color: Colors.white, size: 32)),
              // const SizedBox(width: 5),
              const Icon(Icons.notifications, color: Colors.white, size: 32),
              // const SizedBox(width: 5),
              IconButton(
                  onPressed: () {
                    handleLogout(context);
                  },
                  icon:
                      const Icon(Icons.logout, color: Colors.white, size: 32)),
            ],
          ),
        ],
      ),
    );
  }
}
