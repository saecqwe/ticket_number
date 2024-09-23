import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Text(
                  AppStrings.menuHeader,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: theme.iconTheme.color),
            title: Text(AppStrings.home, style: theme.textTheme.bodySmall),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: theme.iconTheme.color),
            title: Text(AppStrings.settings, style: theme.textTheme.bodySmall),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail, color: theme.iconTheme.color),
            title: Text(AppStrings.contactUs, style: theme.textTheme.bodySmall),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
