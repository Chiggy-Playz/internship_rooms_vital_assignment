import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/device_details/device_details.dart';

class ShareDeviceModal extends StatefulWidget {
  const ShareDeviceModal({super.key});

  @override
  _ShareDeviceModalState createState() => _ShareDeviceModalState();
}

class _ShareDeviceModalState extends State<ShareDeviceModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedUsers = [];

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedUsers.contains(userId)) {
        _selectedUsers.remove(userId);
      } else {
        _selectedUsers.add(userId);
      }
    });
  }

  void _shareAccess() async {
    context
        .read<DeviceDetailsBloc>()
        .add(DeviceDetailsShareDevice(userIds: _selectedUsers));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
      builder: (context, state) {
        if (state is! DeviceDetailsLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Share Device Access",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by email...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (q) => context
                    .read<DeviceDetailsBloc>()
                    .add(DeviceDetailsSearchUserChanged(query: q)),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = state.searchResults[index];
                    final bool isSelected =
                        _selectedUsers.contains(user["uid"]);
                    return ListTile(
                      title: Text(user["email"]),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected ? context.colorScheme.primary : null,
                      ),
                      onTap: () => _toggleSelection(user["uid"]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectedUsers.isEmpty ? null : _shareAccess,
                child: const Text("Share Access"),
              ),
            ],
          ),
        );
      },
    );
  }
}
