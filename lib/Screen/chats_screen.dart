import 'package:flutter/material.dart';
import 'package:studio_project/model/chats.dart';


class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<ChatsModel> LatestChats =[
    ChatsModel(
      image: "https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg?cs=srgb&dl=pexels-pixabay-56866.jpg&fm=jpg",
      contact: "Rawan Ahmad",
      lastMessage: "مرحبا",
      time: "18:09",
    ),
    ChatsModel(
      image: "https://img.freepik.com/free-photo/vertical-closeup-shot-beautiful-aster-flower-covered-dewdrops_181624-55377.jpg?semt=ais_incoming&w=740&q=80",
      contact: "Reem Ahmad",
      lastMessage: "Hello",
      time: "17:20",
    ),
    ChatsModel(
      image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNkae13lC2z-6SY82TI3TeaVmY_wEWcEGRhA&s",
      contact: "Ahmad Ahmad",
      lastMessage: "how r u?",
      time: "17:09",
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
        body: Column(
            children: [
        Padding(padding: const EdgeInsets.all(8)),
    Row(  children: [
    SizedBox(width: 10,),
    Text("Broadcast Lists", style: const TextStyle(
    fontSize: 18,color: Colors.blue)),
    SizedBox(width: 210,),
    Text("New Group", style: const TextStyle(
    fontSize: 18,color: Colors.blue)),
    ], ),
    Padding(padding: const EdgeInsets.all(8)),
    Row(
    children: [
    Container(width:110,height: 80,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text("andolph", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    SizedBox(height: 6),
    Text("m is awsem", style: TextStyle(fontSize: 18, color: Colors.grey)),
    ],
    ),
    ),
    SizedBox(width: 50),
    Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Text("11/11/2025", style: TextStyle(fontSize: 18, color: Colors.grey)),
    SizedBox(height: 4),
    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
    ],
    ),
    Spacer(),
    Container(
    width: 80,
    height: 80,
    color: Colors.grey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.more_horiz, color: Colors.white),
    SizedBox(height: 4),
    Text("More", style: TextStyle(color: Colors.white)),
    ],
    ),
    ),
    Container(
    width: 80,
    height: 80,
    color: Colors.blueAccent,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.archive, color: Colors.white),
    SizedBox(height: 4),
    Text("Archive", style: TextStyle(color: Colors.white)),
    ],
    ),
    ),
    ],
    ),

    Expanded(child:
    ListView.separated(
    itemCount: LatestChats.length,

    itemBuilder: (context, index) {
    return  Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
    child: Row(
    children: [
    Container(
    height: 85,
    width: 85,
    decoration: BoxDecoration(shape: BoxShape.circle,
    image: LatestChats[index].image !=""? DecorationImage(
    image: NetworkImage(LatestChats[index].image!),
    fit: BoxFit.cover,)
        : null,
    ),
    ),
    const SizedBox(width: 12),
    Expanded(child:
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    LatestChats[index].contact??"",
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 6,),
    Text(
    LatestChats[index].lastMessage??"",
    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
    overflow: TextOverflow.ellipsis,
    ),



    ],

    )
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Text(
    LatestChats[index].time ?? "",
    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
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

    )),],), );
  }
}
