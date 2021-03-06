import 'package:flappwritechat/models/user.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<User>((ref) => null);
final channelsProvider = FutureProvider((ref) =>ApiService.instance.getChannels());