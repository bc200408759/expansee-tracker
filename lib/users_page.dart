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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              height: 16), // Spacing between button row and category list

          // Category List
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return userCards.isNotEmpty
                          ? userCards[index]
                          : const Center(
                              child: Text('No categories available'));
                    },
                    childCount: userCards.length,
                  ),
                ),
              ],
            ),
          ),

          // Add Button at the bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _addButtonTapped,
              backgroundColor: const Color.fromARGB(
                  255, 232, 159, 243), // Vibrant color for visibility
              child: const Icon(
                Icons.add,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          TextField(
            onChanged: _onNameChanged,
            maxLength: 40,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between elements

          // Name Validator Message
          if (nameValidator != ValidationOptions.valid)
            Text(
              nameValidator == ValidationOptions.empty
                  ? "Name can't be empty"
                  : "Invalid name",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),

          const SizedBox(height: 24), // Spacing

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _onAddButtonTapped,
                  child: const Text("Done"),
                ),
              ),
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
      padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          TextField(
            onChanged: _onNameChanged,
            maxLength: 40,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between elements

          // Name Validator Message
          if (nameValidator != ValidationOptions.valid)
            Text(
              nameValidator == ValidationOptions.empty
                  ? "Name can't be empty"
                  : "Invalid name",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),

          const SizedBox(height: 24), // Spacing

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _onDoneButtonTapped,
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
