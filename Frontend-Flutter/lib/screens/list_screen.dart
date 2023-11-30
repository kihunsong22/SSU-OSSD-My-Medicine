import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/user_model.dart';
import 'package:medicineapp/screens/ui_consts.dart';
import 'package:medicineapp/services/api_services.dart';
import 'package:medicineapp/widgets/prescription_widget.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // final username, password;
  final uid = "2000";

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    late Future<int> serverStatus = apiService.pingServer();
    late Future<UserModel> userData = apiService.getUserInfo(uid);
    late Future<PrescListModel> prescList = apiService.getPrescList(uid);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: ListScreenAppBarWidget(onRefresh: () {
          setState(() {});
        }),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
            width: 1,
          ),
          Expanded(
            child: FutureBuilder(
              future: serverStatus,
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
                  if (snapshot.data != 204) {
                    return const Center(
                      child: Text('Server status error'),
                    );
                  } else {
                    // return const Placeholder();
                    return FutureBuilder(
                      future: prescList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                ),
                                child: PrescWidget(
                                    data: snapshot.data?.prescId[index] ?? -1),
                              );
                            },
                          );
                        }
                      },
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

class ListScreenAppBarWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const ListScreenAppBarWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        // vertical: 40,
        left: 20,
        right: 5,
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
                      const Icon(Icons.refresh, color: Colors.white, size: 35)),
              const SizedBox(width: 5),
              const Icon(Icons.notifications, color: Colors.white, size: 35),
              const SizedBox(width: 5),
              const Icon(Icons.person, color: Colors.white, size: 35),
            ],
          ),
        ],
      ),
    );
  }
}
