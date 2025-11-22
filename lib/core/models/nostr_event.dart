import 'dart:convert';
import 'package:crypto/crypto.dart';

class NostrEvent {
  final String id;
  final String pubkey;
  final int createdAt;
  final int kind;
  final List<List<String>> tags;
  final String content;
  final String sig;

  NostrEvent({
    required this.id,
    required this.pubkey,
    required this.createdAt,
    required this.kind,
    required this.tags,
    required this.content,
    required this.sig,
  });

  factory NostrEvent.fromJson(Map<String, dynamic> json) {
    return NostrEvent(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      createdAt: json['created_at'] as int,
      kind: json['kind'] as int,
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => (tag as List<dynamic>).cast<String>().toList())
          .toList(),
      content: json['content'] as String? ?? '',
      sig: json['sig'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pubkey': pubkey,
    'created_at': createdAt,
    'kind': kind,
    'tags': tags,
    'content': content,
    'sig': sig,
  };

  List<dynamic> toNip01Array() => [
    'EVENT',
    {
      'id': id,
      'pubkey': pubkey,
      'created_at': createdAt,
      'kind': kind,
      'tags': tags,
      'content': content,
      'sig': sig,
    },
  ];
}

class NostrEventBuilder {
  static String createEventId(
    int kind,
    String pubkey,
    int createdAt,
    List<List<String>> tags,
    String content,
  ) {
    final eventData = [0, pubkey, createdAt, kind, tags, content];
    final serialized = jsonEncode(eventData);
    return sha256.convert(utf8.encode(serialized)).toString();
  }
}

class NostrTag {
  static List<String> dTag(String value) => ['d', value];
  static List<String> aTag(String value) => ['a', value];
  static List<String> eTag(String eventId) => ['e', eventId];
  static List<String> pTag(String pubkey) => ['p', pubkey];
  static List<String> tTag(String hashTag) => ['t', hashTag];
  static List<String> mTag(String mimeType) => ['m', mimeType];
  static List<String> titleTag(String title) => ['title', title];
}

class Filter {
  final List<String>? ids;
  final List<String>? authors;
  final List<int>? kinds;
  final List<String>? e; // #e
  final List<String>? p; // #p
  final List<String>? d; // #d
  final int? since;
  final int? until;
  final int? limit;

  Filter({
    this.ids,
    this.authors,
    this.kinds,
    this.e,
    this.p,
    this.d,
    this.since,
    this.until,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ids != null) map['ids'] = ids;
    if (authors != null) map['authors'] = authors;
    if (kinds != null) map['kinds'] = kinds;
    if (e != null) map['#e'] = e;
    if (p != null) map['#p'] = p;
    if (d != null) map['#d'] = d;
    if (since != null) map['since'] = since;
    if (until != null) map['until'] = until;
    if (limit != null) map['limit'] = limit;
    return map;
  }
}
