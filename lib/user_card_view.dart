import 'package:expences_tracker_with_flutter/financial_tracker.dart';
import 'package:flutter/material.dart';
import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/users_page.dart';

class UserCardView extends StatefulWidget {
  const UserCardView({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onChangeUserName,
    required this.callerContext,
    required this.onSwitchUser,
    required this.onDeleteUser,
    required this.themeColor,
  });

  final User user;
  final bool isSelected;
  final void Function(String id, String newName) onChangeUserName;
  final BuildContext callerContext;
  final void Function(String id) onSwitchUser;
  final void Function(String id) onDeleteUser;
  final HSLColor themeColor;

  @override
  State<StatefulWidget> createState() {
    return _UserCardViewState();
  }
}

class _UserCardViewState extends State<UserCardView> {
  void _onEditUserTapped() {
    showBottomSheet(
      context: widget.callerContext,
      builder: (context_) {
        return EditUser(
          onChangeUserName: widget.onChangeUserName,
          user: widget.user,
          themeColor: widget.themeColor,
        );
      },
    );
  }

  void _onSwitchUserTapped() {
    widget.onSwitchUser(widget.user.id);
  }

  void _onDeleteUserTapped() {
    widget.onDeleteUser(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeColor.toColor(),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Switch User Icon Button
          IconButton(
            onPressed: _onSwitchUserTapped,
            icon: Icon(
              Icons.switch_account,
              color: widget.isSelected ? widget.themeColor.toColor(): Colors.grey,
            ),
            tooltip: 'Switch User',
          ),
          // User Name with Flexibility for Adjusting Longer Names
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.user.Name,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          // Edit Icon Button
          IconButton(
            onPressed: _onEditUserTapped,
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit User',
          ),
          // Delete Icon Button
          IconButton(
            onPressed: _onDeleteUserTapped,
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Delete User',
          ),
        ],
      ),
    );
  }
}

enum ValidationOptions {
  valid,
  invalied,
  empty,
  negative,
}
