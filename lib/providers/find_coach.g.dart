// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_coach.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findAvailableCoachesHash() =>
    r'2f0af68ce63c03b30d40d0fc72e0a8305783ffcf';

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

/// See also [findAvailableCoaches].
@ProviderFor(findAvailableCoaches)
const findAvailableCoachesProvider = FindAvailableCoachesFamily();

/// See also [findAvailableCoaches].
class FindAvailableCoachesFamily
    extends Family<AsyncValue<List<CoachTravelEstimate>>> {
  /// See also [findAvailableCoaches].
  const FindAvailableCoachesFamily();

  /// See also [findAvailableCoaches].
  FindAvailableCoachesProvider call(
    Booking booking,
  ) {
    return FindAvailableCoachesProvider(
      booking,
    );
  }

  @override
  FindAvailableCoachesProvider getProviderOverride(
    covariant FindAvailableCoachesProvider provider,
  ) {
    return call(
      provider.booking,
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
  String? get name => r'findAvailableCoachesProvider';
}

/// See also [findAvailableCoaches].
class FindAvailableCoachesProvider
    extends AutoDisposeFutureProvider<List<CoachTravelEstimate>> {
  /// See also [findAvailableCoaches].
  FindAvailableCoachesProvider(
    Booking booking,
  ) : this._internal(
          (ref) => findAvailableCoaches(
            ref as FindAvailableCoachesRef,
            booking,
          ),
          from: findAvailableCoachesProvider,
          name: r'findAvailableCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findAvailableCoachesHash,
          dependencies: FindAvailableCoachesFamily._dependencies,
          allTransitiveDependencies:
              FindAvailableCoachesFamily._allTransitiveDependencies,
          booking: booking,
        );

  FindAvailableCoachesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.booking,
  }) : super.internal();

  final Booking booking;

  @override
  Override overrideWith(
    FutureOr<List<CoachTravelEstimate>> Function(
            FindAvailableCoachesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindAvailableCoachesProvider._internal(
        (ref) => create(ref as FindAvailableCoachesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        booking: booking,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CoachTravelEstimate>> createElement() {
    return _FindAvailableCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindAvailableCoachesProvider && other.booking == booking;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindAvailableCoachesRef
    on AutoDisposeFutureProviderRef<List<CoachTravelEstimate>> {
  /// The parameter `booking` of this provider.
  Booking get booking;
}

class _FindAvailableCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<CoachTravelEstimate>>
    with FindAvailableCoachesRef {
  _FindAvailableCoachesProviderElement(super.provider);

  @override
  Booking get booking => (origin as FindAvailableCoachesProvider).booking;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
