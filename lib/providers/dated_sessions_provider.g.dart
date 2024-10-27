// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dated_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$datedSessionsHash() => r'ad575f468c5513e1a1f3785fa2564df531b73648';

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

abstract class _$DatedSessions
    extends BuildlessAutoDisposeStreamNotifier<List<Session>> {
  late final DateTime startDate;
  late final DateTime endDate;

  Stream<List<Session>> build({
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// See also [DatedSessions].
@ProviderFor(DatedSessions)
const datedSessionsProvider = DatedSessionsFamily();

/// See also [DatedSessions].
class DatedSessionsFamily extends Family<AsyncValue<List<Session>>> {
  /// See also [DatedSessions].
  const DatedSessionsFamily();

  /// See also [DatedSessions].
  DatedSessionsProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return DatedSessionsProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  DatedSessionsProvider getProviderOverride(
    covariant DatedSessionsProvider provider,
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
  String? get name => r'datedSessionsProvider';
}

/// See also [DatedSessions].
class DatedSessionsProvider extends AutoDisposeStreamNotifierProviderImpl<
    DatedSessions, List<Session>> {
  /// See also [DatedSessions].
  DatedSessionsProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          () => DatedSessions()
            ..startDate = startDate
            ..endDate = endDate,
          from: datedSessionsProvider,
          name: r'datedSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$datedSessionsHash,
          dependencies: DatedSessionsFamily._dependencies,
          allTransitiveDependencies:
              DatedSessionsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  DatedSessionsProvider._internal(
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
  Stream<List<Session>> runNotifierBuild(
    covariant DatedSessions notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(DatedSessions Function() create) {
    return ProviderOverride(
      origin: this,
      override: DatedSessionsProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<DatedSessions, List<Session>>
      createElement() {
    return _DatedSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DatedSessionsProvider &&
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

mixin DatedSessionsRef on AutoDisposeStreamNotifierProviderRef<List<Session>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _DatedSessionsProviderElement
    extends AutoDisposeStreamNotifierProviderElement<DatedSessions,
        List<Session>> with DatedSessionsRef {
  _DatedSessionsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as DatedSessionsProvider).startDate;
  @override
  DateTime get endDate => (origin as DatedSessionsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
