import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:studio_project/model/chats.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<ChatsModel> LatestChats = [
    ChatsModel(
      image:
      "https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg?cs=srgb&dl=pexels-pixabay-56866.jpg&fm=jpg",
      contact: "Rawan Ahmad",
      lastMessage: "مرحبا",
      time: "18:09",
    ),
    ChatsModel(
      image:
      "https://img.freepik.com/free-photo/vertical-closeup-shot-beautiful-aster-flower-covered-dewdrops_181624-55377.jpg?semt=ais_incoming&w=740&q=80",
      contact: "Reem Ahmad",
      lastMessage: "Hello",
      time: "17:20",
    ),
    ChatsModel(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNkae13lC2z-6SY82TI3TeaVmY_wEWcEGRhA&s",
      contact: "Ahmad Ahmad",
      lastMessage: "how r u?",
      time: "17:09",
    ),
    ChatsModel(
      image:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHIIYMmRdXcdMmLgn62zU7S-MNaJbyOyk7cg&s",
      contact: "Sara Hassan",
      lastMessage: "Hello",
      time: "20/11/2025",
    ),
    ChatsModel(
      image:
      "https://www.yourtango.com/sites/default/files/image_blog/2024-12/boys-taught-parents.png",
      contact: "Zain Hassan",
      lastMessage: "Hello",
      time: "19/11/2025",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Edit", style: TextStyle(fontSize: 18, color: Colors.blue)),
            Text("Chats",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Icon(Icons.edit, color: Colors.blue),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: LatestChats.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Slidable(
              key: ValueKey(LatestChats[index].contact),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.45,
                children: [
                  SlidableAction(
                    onPressed: (_) {},
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    icon: Icons.more_horiz,
                    label: 'More',
                  ),
                  SlidableAction(
                    onPressed: (_) {},
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: LatestChats[index].image != ""
                          ? DecorationImage(
                        image:
                        NetworkImage(LatestChats[index].image!),
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
                          LatestChats[index].contact ?? "",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          LatestChats[index].lastMessage ?? "",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LatestChats[index].time ?? "",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
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
      ),
    );
  }
}
