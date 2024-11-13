import 'package:flutter/material.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;


class Friend extends StatelessWidget {
  final Routes.Friend friend;
  final String userEmail;
  final String? type;
  final VoidCallback? onTap;
  final VoidCallback? onAcceptRequest;
  final VoidCallback? onRejectRequest;
  final VoidCallback? onRemoveFriend;
  final VoidCallback? onShowProfile;

  const Friend({
    super.key,
    required this.friend,
    required this.userEmail,
    this.onTap,
    this.type,
    this.onAcceptRequest,
    this.onRejectRequest,
    this.onRemoveFriend,
    this.onShowProfile
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
             _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: _buildUserInfo(context),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
  // if we implement a profile picture type of feature.
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[200],
      child: 
          const Icon(
              Icons.person,
              size: 24,
              color: Colors.grey,
            ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          friend.friendEmail == userEmail ? friend.userEmail : friend.friendEmail,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (friend.userEmail.isNotEmpty && friend.friendEmail.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            friend.friendEmail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (friend.status.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildStatusChip(context),
        ],
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (friend.status.toLowerCase()) {
      case 'online':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        icon = Icons.circle;
        break;
      case 'offline':
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        icon = Icons.circle_outlined;
        break;
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        icon = Icons.pending_outlined;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            friend.status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (friend.status.toLowerCase() == 'pending' && friend.userEmail != userEmail) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            color: Colors.green,
            onPressed: onAcceptRequest,
            tooltip: 'Accept Friend Request',
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            color: Colors.red,
            onPressed: onRejectRequest,
            tooltip: 'Reject Friend Request',
          ),
        ],
      );
    }

    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        _showFriendOptions(context);
      },
    );
  }

  void _showFriendOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: onShowProfile
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.pop(context);
                  // Add message logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Remove Friend'),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: onRemoveFriend
              ),
            ],
          ),
        );
      },
    );
  }

  void viewUserProfile() {

  }
}