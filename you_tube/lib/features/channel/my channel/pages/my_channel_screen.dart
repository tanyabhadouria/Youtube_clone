import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:you_tube/cores/screens/error_page.dart';
import 'package:you_tube/cores/screens/loader.dart';
import 'package:you_tube/features/auth/provider/user_provider.dart';
import 'package:you_tube/features/channel/my%20channel/parts/buttons.dart';
import 'package:you_tube/features/channel/my%20channel/parts/tab_bar.dart';
import 'package:you_tube/features/channel/my%20channel/parts/tab_bar_view.dart';
import 'package:you_tube/features/channel/my%20channel/parts/top_header.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (currentUser) => DefaultTabController(
            length: 7,
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // top header

                      TopHeader(user: currentUser),
                      const Text("More about this channel"),
                      const Buttons(),

                      // create tab bar

                      const PageTabBar(),
                      const TabPages(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
