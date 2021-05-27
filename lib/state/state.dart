import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/models/user.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<User?>((ref) => null);
final channelsProvider = StateProvider<List<Channel>>((ref)=>[]);
final channelsFutureProvider = FutureProvider<List<Channel>>((ref) async {
  final ch = await ApiService.instance.getChannels();
  ref.read(channelsProvider).state = ch;
  return ch;
});