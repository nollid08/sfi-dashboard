// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaves_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leavesHash() => r'c60354a36f1d75bc9d5c8098ebf5c1aa72c0e8de';

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

abstract class _$Leaves
    extends BuildlessAutoDisposeStreamNotifier<List<Leave>> {
  late final IList<String> uids;

  Stream<List<Leave>> build(
    IList<String> uids,
  );
}

/// See also [Leaves].
@ProviderFor(Leaves)
const leavesProvider = LeavesFamily();

/// See also [Leaves].
class LeavesFamily extends Family<AsyncValue<List<Leave>>> {
  /// See also [Leaves].
  const LeavesFamily();

  /// See also [Leaves].
  LeavesProvider call(
    IList<String> uids,
  ) {
    return LeavesProvider(
      uids,
    );
  }

  @override
  LeavesProvider getProviderOverride(
    covariant LeavesProvider provider,
  ) {
    return call(
      provider.uids,
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
  String? get name => r'leavesProvider';
}

/// See also [Leaves].
class LeavesProvider
    extends AutoDisposeStreamNotifierProviderImpl<Leaves, List<Leave>> {
  /// See also [Leaves].
  LeavesProvider(
    IList<String> uids,
  ) : this._internal(
          () => Leaves()..uids = uids,
          from: leavesProvider,
          name: r'leavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$leavesHash,
          dependencies: LeavesFamily._dependencies,
          allTransitiveDependencies: LeavesFamily._allTransitiveDependencies,
          uids: uids,
        );

  LeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uids,
  }) : super.internal();

  final IList<String> uids;

  @override
  Stream<List<Leave>> runNotifierBuild(
    covariant Leaves notifier,
  ) {
    return notifier.build(
      uids,
    );
  }

  @override
  Override overrideWith(Leaves Function() create) {
    return ProviderOverride(
      origin: this,
      override: LeavesProvider._internal(
        () => create()..uids = uids,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uids: uids,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<Leaves, List<Leave>>
      createElement() {
    return _LeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeavesProvider && other.uids == uids;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uids.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LeavesRef on AutoDisposeStreamNotifierProviderRef<List<Leave>> {
  /// The parameter `uids` of this provider.
  IList<String> get uids;
}

class _LeavesProviderElement
    extends AutoDisposeStreamNotifierProviderElement<Leaves, List<Leave>>
    with LeavesRef {
  _LeavesProviderElement(super.provider);

  @override
  IList<String> get uids => (origin as LeavesProvider).uids;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
