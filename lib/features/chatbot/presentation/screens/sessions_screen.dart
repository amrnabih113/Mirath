import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';
import '../../../../core/ui/widgets/sync_indicator.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../domain/entities/session.dart';
import '../cubit/sessions_cubit.dart';
import '../cubit/sessions_state.dart';
import '../widgets/session_list_tile.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late SessionsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SessionsCubit>();
    cubit.loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Sessions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: MyColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => cubit.createTemporary(),
          ),
        ],
      ),
      body: MyBody(
        child: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsLoading) {
              return const Center(child: SyncIndicator(syncing: true));
            }
            if (state is SessionsError) {
              return Center(child: Text(state.message));
            }
            if (state is SessionsLoaded) {
              final sessions = state.sessions;
              if (sessions.isEmpty) {
                return const Center(child: Text('No sessions'));
              }
              return ListView.separated(
                itemCount: sessions.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: MySizes.spaceSm(context)),
                itemBuilder: (_, i) => SessionListTile(
                  session: sessions[i],
                  onDelete: () => cubit.removeSession(sessions[i].id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: SessionDetailScreen(sessionId: sessions[i].id),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class SessionDetailScreen extends StatelessWidget {
  final String sessionId;
  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionsCubit>();
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          'Session',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: MyColors.textPrimary,
          ),
        ),
      ),
      body: MyBody(
        child: FutureBuilder<Session?>(
          future: cubit.getById(sessionId),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: SyncIndicator(syncing: true));
            }
            final session = snap.data;
            if (session == null) return const Center(child: Text('Not found'));
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Session id: ${session.id}'),
                    const SizedBox(height: 8),
                    Text('Title: ${session.title ?? '-'}'),
                    const SizedBox(height: 8),
                    Text('Created at: ${session.createdAt.toString()}'),
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
