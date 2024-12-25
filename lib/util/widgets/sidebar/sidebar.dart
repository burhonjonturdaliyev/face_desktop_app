import 'package:face_app/screens/main/bloc/main_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final Map<int, bool> _isHoveredMap = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (BuildContext context, state) {
        if (state is! MainAllUsersState &&
            state is! MainAddUserState &&
            state is! MainUserManagementState &&
            state is! MainExampleState) {
          context.read<MainBloc>().add(MainScreenSwitchEvent(index: 0));
        }
        return Container(
          width: 260,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Center(
                    child: Text(
                      'Hikvision',
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    )),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home,
                      title: 'All Users',
                      isSelected: state is MainAllUsersState,
                      onTap: () {
                        context.read<MainBloc>().add(MainScreenSwitchEvent(index: 0));
                      },
                      index: 0,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.add,
                      title: 'Add User',
                      isSelected: state is MainAddUserState,
                      onTap: () {
                        context.read<MainBloc>().add(MainScreenSwitchEvent(index: 1));
                      },
                      index: 1,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.person,
                      title: 'User Management',
                      isSelected: state is MainUserManagementState,
                      onTap: () {
                        context.read<MainBloc>().add(MainScreenSwitchEvent(index: 2));
                      },
                      index: 2,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.disabled_by_default,
                      title: 'Example',
                      isSelected: state is MainExampleState,
                      onTap: () {
                        context.read<MainBloc>().add(MainScreenSwitchEvent(index: 3));
                      },
                      index: 3,
                    ),
                  ],
                ),
              ),
              Container(padding: EdgeInsets.symmetric(vertical: 16),
                child: _buildNavItem(
                  context,
                  icon: Icons.logout,
                  title: 'Log Out',
                  isSelected: false,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/',(Route<dynamic> route) => false,);
                              // UserDatas().clearUserDatas;
                            },
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  index: 4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool isSelected,
        required VoidCallback onTap,
        required int index,
      }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final hoverColor = primaryColor.withOpacity(0.3);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHoveredMap[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHoveredMap[index] = false;
        });
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _isHoveredMap[index] == true
                  ? hoverColor
                  : (isSelected
                  ? hoverColor
                  : Colors.transparent),
              border: isSelected
                  ? Border(
                right: BorderSide(
                  color: primaryColor,
                  width: 4,
                ),
              )
                  : null,
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                icon,
                size: 30,
                color: isSelected ? primaryColor : Colors.grey[600],
              ),
              title: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? primaryColor : Colors.black87,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}