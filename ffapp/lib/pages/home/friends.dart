import 'package:flutter/material.dart';
import 'package:ffapp/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/components/friend_list.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/pages/home/profile.dart';

class Friends extends StatefulWidget {
  @override
  State<Friends> createState() => FriendsState();
}

class FriendsState extends State<Friends> with SingleTickerProviderStateMixin {
  late AuthService auth;
  String? userEmail;
  bool isLoading = true;
  String searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initialize() async {
    auth = Provider.of<AuthService>(context, listen: false);
    try {
      Routes.User? user = await auth.getUserDBInfo();
      setState(() {
        userEmail = user!.email;
        isLoading = false;
      });
      Routes.MultiFriends friendList = await auth.getFriends(1);
      Routes.MultiFriends requestList = await auth.getRequests(1);
      logger.i("Getting friend info");
      List<Routes.Friend> friends = friendList.friends;
      List<Routes.Friend> requests = requestList.friends;
      if (mounted) {
        Provider.of<FriendModel>(context, listen: false).setFriendList(friends);
        Provider.of<FriendModel>(context, listen: false)
            .setRequestList(requests);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendModel = context.watch<FriendModel>();
    logger.i(friendModel.toString());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(friendModel),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(friendModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFriendDialog();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(FriendModel friendModel) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          GoRouter.of(context).go('/home');
        },
      ),
      title: const Text('Friends'),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                const Text('Friends'),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    friendModel.friends.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pending_actions),
                const SizedBox(width: 8),
                const Text('Requests'),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    friendModel.requests.length
                        .toString(), // Replace with actual count
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(FriendModel friendModel) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFriendsList(friendModel),
              _buildRequestsList(friendModel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search friends...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFriendsList(FriendModel friendModel) {
    // Mock data - replace with actual data
    // final friends = [
    //   Routes.Friend(friendEmail: "test@example.com", status: "online"),
    //   Routes.Friend(friendEmail: "test1@example.com", status: "online"),
    //   Routes.Friend(friendEmail: "test2@example.com", status: "offline"),
    // ];
    // friends
    return FriendList(
      // am I braindead for this?
      setParentState: () {
        setState(() {});
      },
      userEmail: userEmail ?? "",
      // friends: friends.where((friend) =>
      //   friend.friendEmail.toLowerCase().contains(searchQuery.toLowerCase())
      // ).toList(),
      friends: friendModel.friends,
    );
  }

  Widget _buildRequestsList(FriendModel friendModel) {
    // Mock data - replace with actual data
    // final requests = [
    //   Routes.Friend(friendEmail: "test3@example.com", status: "pending"),
    //   Routes.Friend(
    //       userEmail: "qasyqafy@polkaroad.net",
    //       friendEmail: "test4@example.com",
    //       status: "pending"),
    // ];
    // requests
    return FriendList(
        setParentState: () {
          setState(() {});
        },
        userEmail: userEmail ?? "",
        // friends: requests.where((friend) =>
        //   friend.friendEmail.toLowerCase().contains(searchQuery.toLowerCase())
        // ).toList(),
        type: "request",
        friends: friendModel.requests);
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';

        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter friend\'s email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  Routes.Friend friend = await auth.sendFriendRequest(email);
                  Provider.of<FriendModel>(context, listen: false)
                      .requests
                      .add(friend);
                  Navigator.of(context).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Friend request successfully sent!"),
                  ));
                } on InvalidEmailException {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "No user found with this email. Please check the email address and try again."),
                  ));
                }
              },
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }
}
