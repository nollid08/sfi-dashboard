// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$futureSessionsHash() => r'a8e49675d4baf2b232fa2157881f3cceee9e1cdc';

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

/// See also [futureSessions].
@ProviderFor(futureSessions)
const futureSessionsProvider = FutureSessionsFamily();

/// See also [futureSessions].
class FutureSessionsFamily extends Family<AsyncValue<List<Session>>> {
  /// See also [futureSessions].
  const FutureSessionsFamily();

  /// See also [futureSessions].
  FutureSessionsProvider call({
    required String? coachUid,
  }) {
    return FutureSessionsProvider(
      coachUid: coachUid,
    );
  }

  @override
  FutureSessionsProvider getProviderOverride(
    covariant FutureSessionsProvider provider,
  ) {
    return call(
      coachUid: provider.coachUid,
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
  String? get name => r'futureSessionsProvider';
}

/// See also [futureSessions].
class FutureSessionsProvider extends AutoDisposeStreamProvider<List<Session>> {
  /// See also [futureSessions].
  FutureSessionsProvider({
    required String? coachUid,
  }) : this._internal(
          (ref) => futureSessions(
            ref as FutureSessionsRef,
            coachUid: coachUid,
          ),
          from: futureSessionsProvider,
          name: r'futureSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$futureSessionsHash,
          dependencies: FutureSessionsFamily._dependencies,
          allTransitiveDependencies:
              FutureSessionsFamily._allTransitiveDependencies,
          coachUid: coachUid,
        );

  FutureSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coachUid,
  }) : super.internal();

  final String? coachUid;

  @override
  Override overrideWith(
    Stream<List<Session>> Function(FutureSessionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FutureSessionsProvider._internal(
        (ref) => create(ref as FutureSessionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coachUid: coachUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Session>> createElement() {
    return _FutureSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FutureSessionsProvider && other.coachUid == coachUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coachUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FutureSessionsRef on AutoDisposeStreamProviderRef<List<Session>> {
  /// The parameter `coachUid` of this provider.
  String? get coachUid;
}

class _FutureSessionsProviderElement
    extends AutoDisposeStreamProviderElement<List<Session>>
    with FutureSessionsRef {
  _FutureSessionsProviderElement(super.provider);

  @override
  String? get coachUid => (origin as FutureSessionsProvider).coachUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
