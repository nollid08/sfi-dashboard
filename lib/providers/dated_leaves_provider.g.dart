// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dated_leaves_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$datedLeavesHash() => r'c250b0dcb01a3943436e3b07c41f7242780b1737';

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

abstract class _$DatedLeaves
    extends BuildlessAutoDisposeStreamNotifier<List<Leave>> {
  late final DateTime startDate;
  late final DateTime endDate;

  Stream<List<Leave>> build({
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// See also [DatedLeaves].
@ProviderFor(DatedLeaves)
const datedLeavesProvider = DatedLeavesFamily();

/// See also [DatedLeaves].
class DatedLeavesFamily extends Family<AsyncValue<List<Leave>>> {
  /// See also [DatedLeaves].
  const DatedLeavesFamily();

  /// See also [DatedLeaves].
  DatedLeavesProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return DatedLeavesProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  DatedLeavesProvider getProviderOverride(
    covariant DatedLeavesProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'datedLeavesProvider';
}

/// See also [DatedLeaves].
class DatedLeavesProvider
    extends AutoDisposeStreamNotifierProviderImpl<DatedLeaves, List<Leave>> {
  /// See also [DatedLeaves].
  DatedLeavesProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          () => DatedLeaves()
            ..startDate = startDate
            ..endDate = endDate,
          from: datedLeavesProvider,
          name: r'datedLeavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$datedLeavesHash,
          dependencies: DatedLeavesFamily._dependencies,
          allTransitiveDependencies:
              DatedLeavesFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  DatedLeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Stream<List<Leave>> runNotifierBuild(
    covariant DatedLeaves notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(DatedLeaves Function() create) {
    return ProviderOverride(
      origin: this,
      override: DatedLeavesProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<DatedLeaves, List<Leave>>
      createElement() {
    return _DatedLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DatedLeavesProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DatedLeavesRef on AutoDisposeStreamNotifierProviderRef<List<Leave>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _DatedLeavesProviderElement
    extends AutoDisposeStreamNotifierProviderElement<DatedLeaves, List<Leave>>
    with DatedLeavesRef {
  _DatedLeavesProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as DatedLeavesProvider).startDate;
  @override
  DateTime get endDate => (origin as DatedLeavesProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
