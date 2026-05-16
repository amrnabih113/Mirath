import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_cubit.dart';
import 'package:mirath/features/interests/presentation/cubit/interests_state.dart';
import '../../../../core/network/network_manager.dart';
import '../../../../core/ui/widgets/state_views.dart';

class EditInterstsScreen extends StatefulWidget {
  const EditInterstsScreen({super.key, this.initialSelected = const []});
  final List<String> initialSelected;

  @override
  State<EditInterstsScreen> createState() => _EditInterstsScreenState();
}

class _EditInterstsScreenState extends State<EditInterstsScreen> {
  final List<String> _selected = [];
  final TextEditingController _searchController = TextEditingController();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  String _query = '';
  List<String> _allInterests = [];

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initialSelected);

    context.read<InterestsCubit>().getAllInterests();
  }

  void _toggleInterest(String name) {
    setState(() {
      _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
    });

    _updateOverlay(); // refresh dropdown after selection
  }

  void _showOverlay() {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final filtered = _allInterests
            .where(
              (i) =>
                  i.toLowerCase().contains(_query.toLowerCase()) &&
                  !_selected.contains(i),
            )
            .toList();

        if (_query.isEmpty || filtered.isEmpty) {
          return const SizedBox();
        }

        return Positioned(
          width: MediaQuery.of(context).size.width * 0.9,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 55),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final interest = filtered[index];

                    return ListTile(
                      title: Text(interest),
                      onTap: () {
                        _toggleInterest(interest);
                        _searchController.clear();
                        _query = '';
                        _updateOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    _showOverlay();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MyBackIcon(),
        title: const Text('Interests'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Padding(
            padding: MySizes.paddingSm(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit your interests',
                  style: context.headlineLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // 🔍 Search with overlay anchor
                CompositedTransformTarget(
                  link: _layerLink,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search interests',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                      _showOverlay();
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 🟢 Selected chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selected.map((e) {
                    return GestureDetector(
                      onTap: () => _toggleInterest(e),
                      child: TagChip(label: e, hasIcon: true),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // 📦 Load interests once
                Expanded(
                  child: BlocBuilder<InterestsCubit, InterestsState>(
                    builder: (context, state) {
                      if (state is InterestsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is InterestsError) {
                        final offline =
                            !NetworkManager.instance.currentConnectionStatus;
                        return offline
                            ? OfflineStateView(
                                title: 'Offline',
                                message: state.message,
                                actionLabel: 'Retry',
                                onAction: () => context
                                    .read<InterestsCubit>()
                                    .getAllInterests(),
                              )
                            : ErrorStateView(
                                title: 'Error',
                                message: state.message,
                                actionLabel: 'Retry',
                                onAction: () => context
                                    .read<InterestsCubit>()
                                    .getAllInterests(),
                              );
                      }

                      if (state is InterestsLoaded) {
                        _allInterests = state.interests
                            .map((e) => e.name)
                            .toList();
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(_selected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryShade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
