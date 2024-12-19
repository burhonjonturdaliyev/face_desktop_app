import 'package:flutter/material.dart';

import '../add_user/add_user_screen.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUserScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    users = [
      {
        "name": "Alice Johnson",
        "email": "alice@example.com",
        "status": "Active",
        "profilePicture": "https://via.placeholder.com/150"
      },
      {
        "name": "Bob Smith",
        "email": "bob@example.com",
        "status": "Inactive",
        "profilePicture": null
      },
      {
        "name": "Charlie Brown",
        "email": "charlie@example.com",
        "status": "Active",
        "profilePicture": "https://via.placeholder.com/150"
      },
      {
        "name": "Daisy Ridley",
        "email": "daisy@example.com",
        "status": "Active",
        "profilePicture": null
      },
      {
        "name": "Ethan Hunt",
        "email": "ethan@example.com",
        "status": "Inactive",
        "profilePicture": "https://via.placeholder.com/150"
      },
    ];
    filteredUsers = List.from(users);
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(users);
      } else {
        filteredUsers = users
            .where((user) =>
        user['name'].toLowerCase().contains(query.toLowerCase()) ||
            user['email'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                filteredUsers = List.from(users);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return buildUserTile(user);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        onChanged: filterUsers,
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildUserTile(Map<String, dynamic> user) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user['status'] == 'Active' ? Colors.green : Colors.red,
          backgroundImage: user['profilePicture'] != null
              ? NetworkImage(user['profilePicture'])
              : null,
          child: user['profilePicture'] == null
              ? Text(user['name'][0], style: const TextStyle(color: Colors.white))
              : null,
        ),
        title: Text(user['name']),
        subtitle: Text(user['email']),
        trailing: Text(
          user['status'],
          style: TextStyle(
            color: user['status'] == 'Active' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${user['name']}')),
          );
        },
      ),
    );
  }
}