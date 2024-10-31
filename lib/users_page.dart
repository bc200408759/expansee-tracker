//view class

import 'package:flutter/material.dart';
import 'package:expences_tracker_with_flutter/user.dart';
import 'package:expences_tracker_with_flutter/user_card_view.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
    required this.usersList,
    required this.selectedUserId,
    required this.onAddUser,
    required this.onChangeUserName,
    required this.onSwitchUser,
    required this.onDeleteUser,
  });

  final UsersListManager usersList;
  final String selectedUserId;
  final void Function(String userName) onAddUser;
  final void Function(String id, String name) onChangeUserName;
  final void Function(String id) onSwitchUser;
  final void Function(String id) onDeleteUser;

  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late List<UserCardView> userCards;

  void _addButtonTapped() {
    showBottomSheet(
      context: context,
      builder: (context_) {
        return AddUser(
          onAddUser: widget.onAddUser,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    userCards = widget.usersList.map((user) {
      return UserCardView(
        user: user,
        isSelected: widget.selectedUserId == user.id,
        onChangeUserName: widget.onChangeUserName,
        callerContext: context,
        onSwitchUser: widget.onSwitchUser,
        onDeleteUser: widget.onDeleteUser,
      );
    }).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: _addButtonTapped,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Column(
          children: userCards,
        )
      ],
    );
  }
}


//Overlay bottom sheet to add user


class AddUser extends StatefulWidget {
  const AddUser({
    super.key,
    required this.onAddUser,
  });

  final void Function(String userName) onAddUser;

  @override
  State<StatefulWidget> createState() {
    return _AddUserState();
  }
}

class _AddUserState extends State<AddUser> {
  //flages to validate the user input
  ValidationOptions nameValidator = ValidationOptions.valid;
  bool addButtonDisabled = false;

  String inputName = '';

  void _onNameChanged(String inputValue) {
    setState(() {
      if (inputValue.isEmpty) {
        nameValidator = ValidationOptions.empty;
      } else {
        inputName = inputValue;
        nameValidator = ValidationOptions.valid;
      }
    });
  }

  ///Saving the new Financial Entry
  void _onAddButtonTapped() {
    setState(() {
      if (addButtonDisabled == false) {
        widget.onAddUser(inputName);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 72, 12, 0),
      child: Column(
        children: [
          TextField(
            onChanged: _onNameChanged,
            maxLength: 40,
            decoration: const InputDecoration(label: Text("Name")),
          ),
          Text(
            nameValidator == ValidationOptions.valid
                ? ""
                : nameValidator == ValidationOptions.empty
                    ? "Name can't be empty"
                    : nameValidator == ValidationOptions.invalied
                        ? "Invalid name"
                        : "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Expanded(
                child: TextButton(
                  onPressed: _onAddButtonTapped,
                  child: const Text("Done"),
                ),
              )
            ],
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



/// Edit user overlay

class EditUser extends StatefulWidget {
  const EditUser({
    super.key,
    required this.onChangeUserName,
    required this.user,
  });

  final void Function(String id, String userName) onChangeUserName;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _EditUserState();
  }
}

class _EditUserState extends State<EditUser> {
  //flages to validate the user input
  ValidationOptions nameValidator = ValidationOptions.valid;
  bool addButtonDisabled = false;

  String newName = '';

  void _onNameChanged(String inputValue) {
    setState(() {
      if (inputValue.isEmpty) {
        nameValidator = ValidationOptions.empty;
      } else {
        newName = inputValue;
        nameValidator = ValidationOptions.valid;
      }
    });
  }

  ///Saving the new Financial Entry
  void _onDoneButtonTapped() {
    setState(() {
      if (addButtonDisabled == false) {
        widget.onChangeUserName(widget.user.id, newName);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 72, 12, 0),
      child: Column(
        children: [
          TextField(
            onChanged: _onNameChanged,
            maxLength: 40,
            decoration: const InputDecoration(label: Text("Name")),
          ),
          Text(
            nameValidator == ValidationOptions.valid
                ? ""
                : nameValidator == ValidationOptions.empty
                    ? "Name can't be empty"
                    : nameValidator == ValidationOptions.invalied
                        ? "Invalid name"
                        : "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Expanded(
                child: TextButton(
                  onPressed: _onDoneButtonTapped,
                  child: const Text("Done"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

