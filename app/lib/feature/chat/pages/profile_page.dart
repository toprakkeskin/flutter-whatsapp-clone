import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/helper/last_seen_message.dart';
import 'package:whatsapp_clone/common/models/user_activity_model.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/utils/coloors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/chat/widgets/custom_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.profilePageBgColor,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverPersistentDelegate(user),
            pinned: true,
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.phoneNumber,
                      style: TextStyle(
                        fontSize: 20,
                        color: context.theme.greyColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      // TODO fix this dummy usage
                      getLastSeenMessage(UserActiviyModel(
                          uid: '',
                          active: true,
                          lastSeen: DateTime.now().millisecondsSinceEpoch)),
                      style: TextStyle(
                        color: context.theme.greyColor,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(icon: Icons.call, text: ' Call'),
                        iconWithText(icon: Icons.video_call, text: 'Video'),
                        iconWithText(icon: Icons.search, text: 'Search'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                title: const Text('Hey there! I am using WhatsApp.'),
                subtitle: Text(
                  '21th February, 2023',
                  style: TextStyle(
                    color: context.theme.greyColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomListTile(
                title: 'Mute notification',
                leading: Icons.notifications,
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              const CustomListTile(
                title: 'Custom notification',
                leading: Icons.music_note,
              ),
              CustomListTile(
                title: 'Media visibility',
                leading: Icons.photo,
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              const CustomListTile(
                title: 'Encryption',
                subTitle:
                    'Messages and calls are end-to-end encrypted, Tap to verify.',
                leading: Icons.lock,
              ),
              const CustomListTile(
                title: 'Disappear messages',
                subTitle: 'Off',
                leading: Icons.timer,
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: CustomIconButton(
                  onTap: () {},
                  minWidth: 35,
                  icon: Icons.group,
                  background: Coloors.greenDark,
                  iconColor: Colors.white,
                ),
                title: Text('Create group with ${user.username}'),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                leading: const Icon(
                  Icons.block,
                  color: Color(0xFFF15C6D),
                ),
                title: Text(
                  'Block ${user.username}',
                  style: const TextStyle(
                    color: Color(0xFFF15C6D),
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                leading: const Icon(
                  Icons.block,
                  color: Color(0xFFF15C6D),
                ),
                title: Text(
                  'Report ${user.username}',
                  style: const TextStyle(
                    color: Color(0xFFF15C6D),
                  ),
                ),
              ),
              SizedBox(height: 300),
              SizedBox(height: 300),
              SizedBox(height: 300),
              SizedBox(height: 300),
              SizedBox(height: 300),
              SizedBox(height: 300),
            ],
          )),
        ],
      ),
    );
  }

  iconWithText({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Coloors.greenDark),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(color: Coloors.greenDark),
          ),
        ],
      ),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  final UserModel user;

  final double minHeaderHeight = kToolbarHeight + 65;
  late final double maxHeaderHeight = minHeaderHeight + 105;
  final double maxImageSize = 130;
  final double minImageSize = 40;

  SliverPersistentDelegate(this.user);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / maxHeaderHeight;
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition =
        (((size.width / 2) - (currentImageSize / 2)) * (1 - percent)).clamp(
      minImageSize,
      maxImageSize + (currentImageSize / 2),
    );
    // log('maxHeaderHeight: $maxHeaderHeight, minHeaderHeight: $minHeaderHeight, maxImageSize: $maxImageSize, minImageSize: $minImageSize, kToolbarHeight: $kToolbarHeight');
    // log('size: $size, shrinkOffset: $shrinkOffset, percent: $percent, currentImageSize: $currentImageSize');

    return Container(
      color: Theme.of(context).colorScheme.background,
      // child: SizedBox(height: 50),
      child: Container(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor!
            .withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 15,
              left: currentImagePosition + 50,
              child: Text(
                user.username,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(percent2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: CustomIconButton(
                onTap: () => Navigator.of(context).pop(),
                icon: Icons.arrow_back,
                iconColor: percent2 > .3
                    ? Colors.white.withOpacity(min(0.3 + percent2, 1))
                    : Theme.of(context)
                        .iconTheme
                        .color
                        ?.withOpacity(1 - percent),
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: CustomIconButton(
                onTap: () {},
                icon: Icons.more_vert,
                iconColor: percent2 > .3
                    ? Colors.white.withOpacity(min(0.3 + percent2, 1))
                    : Theme.of(context)
                        .iconTheme
                        .color
                        ?.withOpacity(1 - percent),
              ),
            ),
            Positioned(
              left: currentImagePosition,
              top: MediaQuery.of(context).viewPadding.top + 5,
              bottom: 0,
              child: Hero(
                tag: 'profile',
                child: Container(
                  width: currentImageSize,
                  // height: currentImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
