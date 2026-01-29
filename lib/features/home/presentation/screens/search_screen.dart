import 'package:flutter/material.dart';
import '../../../common/widgets/my_search_bar.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/search_item.dart';
import '../widgets/search_screen_heading.dart';

class SearchScreen extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final String? headingText;
  final Function()? onSearchChanged;
  final Function()? onItemTap;
  final bool showHeading;
  final Function()? onRemoveTap;

  const SearchScreen({
    required this.items,
    this.hintText = 'Search',
    this.headingText,
    this.onSearchChanged,
    this.onItemTap,
    this.showHeading = true,
    this.onRemoveTap,
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
              (item) =>
                  item.toString().toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
    widget.onSearchChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 60),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 850),
                child: AppBar(
                  toolbarHeight: ResponsiveHelper.responsiveValue(context, 55),
                  leadingWidth: ResponsiveHelper.responsiveValue(context, 60),
                  leading: MyBackIcon(),
                  titleSpacing: 0,
                  title: Padding(
                    padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
                    child: MySearchBar(
                      controller: _searchController,
                      hintText: widget.hintText,
                      showSuffixIcon: true,
                      onChanged: _filterItems,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.showHeading) ...[
                      SearchScreenHeading(),
                      SizedBox(height: MySizes.spaceSm(context)),
                    ],
                    Expanded(
                      child: _filteredItems.isEmpty
                          ? Center(
                              child: Text(
                                'No results found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: MySizes.spaceXs(context)),
                              padding: EdgeInsets.zero,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                return InkWell(
                                  onTap: () => widget.onItemTap!.call(),
                                  child: SearchItem(
                                    itemTitle: item.toString(),
                                    onTap: () => widget.onRemoveTap!.call(),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
