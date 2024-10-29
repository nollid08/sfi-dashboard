// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionsHash() => r'1f40a4058678fa63b069e0356079aeac5e5d0714';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Sessions
    extends BuildlessAutoDisposeStreamNotifier<List<Session>> {
  late final IList<String>? bookingIds;
  late final IList<String>? coachIds;

  Stream<List<Session>> build({
    IList<String>? bookingIds,
    IList<String>? coachIds,
  });
}

/// See also [Sessions].
@ProviderFor(Sessions)
const sessionsProvider = SessionsFamily();

/// See also [Sessions].
class SessionsFamily extends Family<AsyncValue<List<Session>>> {
  /// See also [Sessions].
  const SessionsFamily();

  /// See also [Sessions].
  SessionsProvider call({
    IList<String>? bookingIds,
    IList<String>? coachIds,
  }) {
    return SessionsProvider(
      bookingIds: bookingIds,
      coachIds: coachIds,
    );
  }

  @override
  SessionsProvider getProviderOverride(
    covariant SessionsProvider provider,
  ) {
    return call(
      bookingIds: provider.bookingIds,
      coachIds: provider.coachIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionsProvider';
}

/// See also [Sessions].
class SessionsProvider
    extends AutoDisposeStreamNotifierProviderImpl<Sessions, List<Session>> {
  /// See also [Sessions].
  SessionsProvider({
    IList<String>? bookingIds,
    IList<String>? coachIds,
  }) : this._internal(
          () => Sessions()
            ..bookingIds = bookingIds
            ..coachIds = coachIds,
          from: sessionsProvider,
          name: r'sessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionsHash,
          dependencies: SessionsFamily._dependencies,
          allTransitiveDependencies: SessionsFamily._allTransitiveDependencies,
          bookingIds: bookingIds,
          coachIds: coachIds,
        );

  SessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingIds,
    required this.coachIds,
  }) : super.internal();

  final IList<String>? bookingIds;
  final IList<String>? coachIds;

  @override
  Stream<List<Session>> runNotifierBuild(
    covariant Sessions notifier,
  ) {
    return notifier.build(
      bookingIds: bookingIds,
      coachIds: coachIds,
    );
  }

  @override
  Override overrideWith(Sessions Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionsProvider._internal(
        () => create()
          ..bookingIds = bookingIds
          ..coachIds = coachIds,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingIds: bookingIds,
        coachIds: coachIds,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<Sessions, List<Session>>
      createElement() {
    return _SessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionsProvider &&
        other.bookingIds == bookingIds &&
        other.coachIds == coachIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingIds.hashCode);
    hash = _SystemHash.combine(hash, coachIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionsRef on AutoDisposeStreamNotifierProviderRef<List<Session>> {
  /// The parameter `bookingIds` of this provider.
  IList<String>? get bookingIds;

  /// The parameter `coachIds` of this provider.
  IList<String>? get coachIds;
}

class _SessionsProviderElement
    extends AutoDisposeStreamNotifierProviderElement<Sessions, List<Session>>
    with SessionsRef {
  _SessionsProviderElement(super.provider);

  @override
  IList<String>? get bookingIds => (origin as SessionsProvider).bookingIds;
  @override
  IList<String>? get coachIds => (origin as SessionsProvider).coachIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
