// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaches_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$coachHash() => r'f832ac003a2d8a73d156766d322febc7a64de93d';

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

/// See also [coach].
@ProviderFor(coach)
const coachProvider = CoachFamily();

/// See also [coach].
class CoachFamily extends Family<AsyncValue<Coach>> {
  /// See also [coach].
  const CoachFamily();

  /// See also [coach].
  CoachProvider call(
    String coachId,
  ) {
    return CoachProvider(
      coachId,
    );
  }

  @override
  CoachProvider getProviderOverride(
    covariant CoachProvider provider,
  ) {
    return call(
      provider.coachId,
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
  String? get name => r'coachProvider';
}

/// See also [coach].
class CoachProvider extends AutoDisposeFutureProvider<Coach> {
  /// See also [coach].
  CoachProvider(
    String coachId,
  ) : this._internal(
          (ref) => coach(
            ref as CoachRef,
            coachId,
          ),
          from: coachProvider,
          name: r'coachProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$coachHash,
          dependencies: CoachFamily._dependencies,
          allTransitiveDependencies: CoachFamily._allTransitiveDependencies,
          coachId: coachId,
        );

  CoachProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coachId,
  }) : super.internal();

  final String coachId;

  @override
  Override overrideWith(
    FutureOr<Coach> Function(CoachRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CoachProvider._internal(
        (ref) => create(ref as CoachRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coachId: coachId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Coach> createElement() {
    return _CoachProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CoachProvider && other.coachId == coachId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coachId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CoachRef on AutoDisposeFutureProviderRef<Coach> {
  /// The parameter `coachId` of this provider.
  String get coachId;
}

class _CoachProviderElement extends AutoDisposeFutureProviderElement<Coach>
    with CoachRef {
  _CoachProviderElement(super.provider);

  @override
  String get coachId => (origin as CoachProvider).coachId;
}

String _$coachesHash() => r'82db0c6e53fee5de8712f487d202bcaccaf1ead0';

/// See also [Coaches].
@ProviderFor(Coaches)
final coachesProvider =
    AutoDisposeStreamNotifierProvider<Coaches, List<Coach>>.internal(
  Coaches.new,
  name: r'coachesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$coachesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Coaches = AutoDisposeStreamNotifier<List<Coach>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
