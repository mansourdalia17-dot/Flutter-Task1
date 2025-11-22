import 'package:flutter/material.dart';
import 'package:studio_project/model/calls_model.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  List<CallsModel> LatestCalls = [
    CallsModel(
      image: "https://img.piri.net/mnresize/900/-/resim/upload/2018/12/13/10/07/67ee2ba7dwxf2x4aeuyv7.jpg",
      contactName: "Ruba Mohammad",
      status: "outgoing",
      date: "21/11/2025",
    ),
    CallsModel(
      image: "https://thumbs.dreamstime.com/b/profile-portrait-cute-adorable-first-grader-girl-school-un-uniform-white-bows-long-hair-raised-head-closed-eyes-128377750.jpg",
      contactName: "Hadeel Hassan",
      status: "outgoing",
      date: "20/11/2025",
    ),
    CallsModel(
      image: "https://img.piri.net/mnresize/900/-/resim/upload/2018/12/13/10/07/67ee2ba7dwxf2x4aeuyv7.jpg",
      contactName: "Ruba Mohammad",
      status: "missed",
      date: "18/11/2025",
    ),
    CallsModel(
      image: "https://img.piri.net/mnresize/900/-/resim/upload/2018/12/13/10/07/67ee2ba7dwxf2x4aeuyv7.jpg",
      contactName: "Ruba Mohammad",
      status: "outgoing",
      date: "10/11/2025",
    ),
    CallsModel(
      image: "https://thumbs.dreamstime.com/b/profile-portrait-cute-adorable-first-grader-girl-school-un-uniform-white-bows-long-hair-raised-head-closed-eyes-128377750.jpg",
      contactName: "Hadeel Hassan",
      status: "missed",
      date: "9/11/2025",
    ),
    CallsModel(
      image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNkae13lC2z-6SY82TI3TeaVmY_wEWcEGRhA&s",
      contactName: "Ahmad Ahmad",
      status: "outgoing",
      date: "7/11/2025",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Edit", style: TextStyle(fontSize: 18, color: Colors.blue)),
              Icon(Icons.add_ic_call_rounded, color: Colors.blueAccent),
            ],
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90.0),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.blue,
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Missed'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            buildCallList(),
            buildCallList(showMissedOnly: true),
          ],
        ),
      ),
    );
  }

  Widget buildCallList({bool showMissedOnly = false}) {
    final filteredCalls = showMissedOnly
        ? LatestCalls.where((call) => call.status == 'missed').toList()
        : LatestCalls;

    return ListView.separated(
      itemCount: filteredCalls.length,
      itemBuilder: (context, index) {
        final call = filteredCalls[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: call.image != ""
                      ? DecorationImage(
                    image: NetworkImage(call.image!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      call.contactName ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: call.status == "missed"
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.call, color: Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(
                          call.status ?? "",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    call.date ?? "",
                    style:
                    const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 20,
                color: Colors.blueAccent,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Divider(
            thickness: 0.7,
            color: Colors.grey.shade300,
          ),
        );
      },
    );
  }
}
