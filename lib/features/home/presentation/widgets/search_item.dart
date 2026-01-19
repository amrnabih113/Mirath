import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 20)),
      title: Text(
        'jpojwrpj',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      trailing: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
    );
  }
}
