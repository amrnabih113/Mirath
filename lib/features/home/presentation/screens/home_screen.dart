import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/features/home/presentation/screens/search_screen.dart';
import 'package:mirath/features/home/presentation/widgets/category_items.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _Searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryShade50,
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: MyColors.primaryShade50,
          child: SvgPicture.asset(
            'assets/images/Profile picture.svg',
            fit: BoxFit.cover,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              color: Colors.black,
            ),
          ),
        ],
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Jhon do',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TextField(
                  cursorColor: MyColors.primaryShade500,
                  readOnly: true,
                  onTap: () {
                    context.push('/search');
                  },
                  controller: _Searchcontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.primaryShade50,

                    prefixIcon: Icon(Icons.search, color: Colors.black),

                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
                    ),

                    hintText: 'Search papers, authors, keywords...',

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: MyColors.primaryShade700,
                        width: 1.2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: MyColors.primaryShade700,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recently Published',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 100),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xffA80C0C),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13,
                                  color: Color(0xffA80C0C),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return CategoryItems();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You might also like',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return PaperCardItems();
            }, childCount: 10),
          ),
        ],
      ),
    );
  }
}
