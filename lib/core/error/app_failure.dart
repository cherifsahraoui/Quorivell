/// Marker for every typed failure that may cross a repository boundary.
///
/// Guards use this to tell an already-mapped failure apart from a raw
/// infrastructure exception that still needs translating.
abstract interface class AppFailure implements Exception {}
