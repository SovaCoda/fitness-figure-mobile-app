import 'package:ffapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:ffapp/services/routes.pbgrpc.dart' as grpc;
import 'package:ffapp/components/friend.dart';
import 'package:provider/provider.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/components/profile_page.dart';

class FriendList extends StatefulWidget {
  final String userEmail;
  final List<Routes.Friend> friends;
  final Function()? onLoadMore;
  final String? type;
  final bool isLoading;
  final Function()? setParentState;

  const FriendList({
    Key? key,
    required this.friends,
    required this.userEmail,
    this.type,
    this.onLoadMore,
    this.isLoading = false,
    required this.setParentState,
  }) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final ScrollController _scrollController = ScrollController();
  late AuthService auth;
  static const int _pageSize = 10; // unused for now

  @override
  void initState() {
    auth = Provider.of<AuthService>(context, listen: false);
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (widget.onLoadMore != null && !widget.isLoading) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            minHeight: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: widget.friends.isEmpty
                    ? _buildEmptyState()
                    : _buildFriendsList(),
              ),
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No friends yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding friends to see them here',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.friends.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final friend = widget.friends[index];
        // TODO: POTENTIALLY BUG INFESTED CODE
        return Friend(
          friend: friend,
          type: widget.type,
          userEmail: widget.userEmail,
          onAcceptRequest: () async {
            Routes.Friend newFriend = await auth.acceptFriendRequest(friend.userEmail);
            Provider.of<FriendModel>(context, listen: false).friends.add(newFriend);
            Provider.of<FriendModel>(context, listen: false).requests.removeAt(index);
            widget.setParentState!();
          },
          onRejectRequest: () async {
            Routes.Friend rejectedFriend = await auth.rejectFriendRequest(friend.userEmail);
            Provider.of<FriendModel>(context, listen: false).requests.removeAt(index);
            widget.setParentState!();
          },
          onRemoveFriend: () async {
            await auth.removeFriend(friend.friendEmail);
            Provider.of<FriendModel>(context, listen: false).friends.removeAt(index);
            widget.setParentState!();
          },
          onShowProfile: () async {
            Routes.User? user = await auth.getUserFromEmail(Routes.User(email: friend.friendEmail));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: user),
              ),
            );
          }
        );
      },
    );
  }
}

