// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_sessions_and_leaves.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$futureSessionsAndLeavesHash() =>
    r'79ccbf49831e2a2f950b3a5a27d20d9f413e4981';

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

/// See also [futureSessionsAndLeaves].
@ProviderFor(futureSessionsAndLeaves)
const futureSessionsAndLeavesProvider = FutureSessionsAndLeavesFamily();

/// See also [futureSessionsAndLeaves].
class FutureSessionsAndLeavesFamily
    extends Family<AsyncValue<Map<String, List>>> {
  /// See also [futureSessionsAndLeaves].
  const FutureSessionsAndLeavesFamily();

  /// See also [futureSessionsAndLeaves].
  FutureSessionsAndLeavesProvider call(
    String uid,
  ) {
    return FutureSessionsAndLeavesProvider(
      uid,
    );
  }

  @override
  FutureSessionsAndLeavesProvider getProviderOverride(
    covariant FutureSessionsAndLeavesProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'futureSessionsAndLeavesProvider';
}

/// See also [futureSessionsAndLeaves].
class FutureSessionsAndLeavesProvider
    extends AutoDisposeStreamProvider<Map<String, List>> {
  /// See also [futureSessionsAndLeaves].
  FutureSessionsAndLeavesProvider(
    String uid,
  ) : this._internal(
          (ref) => futureSessionsAndLeaves(
            ref as FutureSessionsAndLeavesRef,
            uid,
          ),
          from: futureSessionsAndLeavesProvider,
          name: r'futureSessionsAndLeavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$futureSessionsAndLeavesHash,
          dependencies: FutureSessionsAndLeavesFamily._dependencies,
          allTransitiveDependencies:
              FutureSessionsAndLeavesFamily._allTransitiveDependencies,
          uid: uid,
        );

  FutureSessionsAndLeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<Map<String, List>> Function(FutureSessionsAndLeavesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FutureSessionsAndLeavesProvider._internal(
        (ref) => create(ref as FutureSessionsAndLeavesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<String, List>> createElement() {
    return _FutureSessionsAndLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FutureSessionsAndLeavesProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FutureSessionsAndLeavesRef
    on AutoDisposeStreamProviderRef<Map<String, List>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _FutureSessionsAndLeavesProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, List>>
    with FutureSessionsAndLeavesRef {
  _FutureSessionsAndLeavesProviderElement(super.provider);

  @override
  String get uid => (origin as FutureSessionsAndLeavesProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
