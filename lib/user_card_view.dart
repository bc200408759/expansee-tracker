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
  });

  final User user;
  final bool isSelected;
  final void Function(String id, String newName) onChangeUserName;
  final BuildContext callerContext;
  final void Function(String id) onSwitchUser;
  final void Function(String id) onDeleteUser;


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
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
        color: widget.isSelected ?
         const Color.fromARGB(197, 214, 36, 137) :
         const Color.fromARGB(197, 226, 184, 208),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _onEditUserTapped,
            icon: const Icon(Icons.edit),
          ),
          Text(
            widget.user.Name,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _onSwitchUserTapped,
            icon: const Icon(Icons.switch_account),
          ),
          IconButton(
            onPressed: _onDeleteUserTapped,
            icon: const Icon(Icons.delete),
          )
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
