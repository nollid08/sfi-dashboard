// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effective_leaves.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$effectiveLeavesHash() => r'1cb3ca29229d7c38a54e58e356a9f0810d0cdb39';

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

/// See also [effectiveLeaves].
@ProviderFor(effectiveLeaves)
const effectiveLeavesProvider = EffectiveLeavesFamily();

/// See also [effectiveLeaves].
class EffectiveLeavesFamily extends Family<AsyncValue<List<Leave>>> {
  /// See also [effectiveLeaves].
  const EffectiveLeavesFamily();

  /// See also [effectiveLeaves].
  EffectiveLeavesProvider call(
    String uid,
  ) {
    return EffectiveLeavesProvider(
      uid,
    );
  }

  @override
  EffectiveLeavesProvider getProviderOverride(
    covariant EffectiveLeavesProvider provider,
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
  String? get name => r'effectiveLeavesProvider';
}

/// See also [effectiveLeaves].
class EffectiveLeavesProvider extends AutoDisposeStreamProvider<List<Leave>> {
  /// See also [effectiveLeaves].
  EffectiveLeavesProvider(
    String uid,
  ) : this._internal(
          (ref) => effectiveLeaves(
            ref as EffectiveLeavesRef,
            uid,
          ),
          from: effectiveLeavesProvider,
          name: r'effectiveLeavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$effectiveLeavesHash,
          dependencies: EffectiveLeavesFamily._dependencies,
          allTransitiveDependencies:
              EffectiveLeavesFamily._allTransitiveDependencies,
          uid: uid,
        );

  EffectiveLeavesProvider._internal(
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
    Stream<List<Leave>> Function(EffectiveLeavesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EffectiveLeavesProvider._internal(
        (ref) => create(ref as EffectiveLeavesRef),
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
  AutoDisposeStreamProviderElement<List<Leave>> createElement() {
    return _EffectiveLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EffectiveLeavesProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EffectiveLeavesRef on AutoDisposeStreamProviderRef<List<Leave>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _EffectiveLeavesProviderElement
    extends AutoDisposeStreamProviderElement<List<Leave>>
    with EffectiveLeavesRef {
  _EffectiveLeavesProviderElement(super.provider);

  @override
  String get uid => (origin as EffectiveLeavesProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
