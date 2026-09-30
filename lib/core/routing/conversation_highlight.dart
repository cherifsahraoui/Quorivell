/// Capture-history route that opens a source conversation with an evidence span.
String conversationSourceHighlightPath({
  required String sourceId,
  required int quoteStart,
  required int quoteEnd,
  String? quoteSnippet,
}) {
  final params = <String, String>{
    'quoteStart': '$quoteStart',
    'quoteEnd': '$quoteEnd',
  };
  final snippet = quoteSnippet?.trim();
  if (snippet != null && snippet.isNotEmpty) {
    params['quoteSnippet'] = snippet;
  }
  return Uri(
    path: '/capture/sources/$sourceId',
    queryParameters: params,
  ).toString();
}
