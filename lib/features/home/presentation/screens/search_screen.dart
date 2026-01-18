import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/search_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _Searchcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.primaryShade50,
      appBar: AppBar(
        leading: MyBackIcon(),
        title: TextField(
          onSubmitted: (value) {},
          controller: _Searchcontroller,
          autofocus: true,
          cursorColor: MyColors.primaryShade500,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.black),

            suffixIcon: IconButton(
              onPressed: () {},
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
            ),

            fillColor: MyColors.primaryShade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: MyColors.primaryShade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: MyColors.primaryShade500),
            ),
          ),
          onChanged: (value) {
            print('Searching for: $value');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SearchItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
