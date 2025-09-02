int? idFromUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final m = RegExp(r'/(\d+)$').firstMatch(url);
  return m != null ? int.tryParse(m.group(1)!) : null;
}
