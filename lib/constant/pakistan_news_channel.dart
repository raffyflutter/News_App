// news_channels_enum.dart
// ignore_for_file: constant_identifier_names

enum PakistaniNewsChannel {
  bolnews,
  Dawn,
  The_News_International,
  ary_news,
}

extension NewsChannelExtension on PakistaniNewsChannel {
  String get displayName {
    switch (this) {
      case PakistaniNewsChannel.bolnews:
        return 'BOL News';
      case PakistaniNewsChannel.Dawn:
        return 'Dawn News';
      case PakistaniNewsChannel.ary_news:
        return 'ARY News';
      case PakistaniNewsChannel.The_News_International:
        return 'The News International';
    }
  }

  String get channelId {
    switch (this) {
      case PakistaniNewsChannel.bolnews:
        return 'BOL News'; // channelId for Geo News
      case PakistaniNewsChannel.Dawn:
        return 'Dawn'; // channelId for ARY News
      case PakistaniNewsChannel.ary_news:
        return 'ARY News'; // channelId for Samaa News
      case PakistaniNewsChannel.The_News_International:
        return 'The_News_International'; // channelId for 92 News
    }
  }
}
