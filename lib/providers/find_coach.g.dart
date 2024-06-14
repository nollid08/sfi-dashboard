// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_coach.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findCoachesHash() => r'be0682f3e799e97be11e3d01cf2ffe774dd4c69b';

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

/// See also [findCoaches].
@ProviderFor(findCoaches)
const findCoachesProvider = FindCoachesFamily();

/// See also [findCoaches].
class FindCoachesFamily extends Family<AsyncValue<List<Coach>>> {
  /// See also [findCoaches].
  const FindCoachesFamily();

  /// See also [findCoaches].
  FindCoachesProvider call(
    Booking booking,
  ) {
    return FindCoachesProvider(
      booking,
    );
  }

  @override
  FindCoachesProvider getProviderOverride(
    covariant FindCoachesProvider provider,
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
  String? get name => r'findCoachesProvider';
}

/// See also [findCoaches].
class FindCoachesProvider extends AutoDisposeFutureProvider<List<Coach>> {
  /// See also [findCoaches].
  FindCoachesProvider(
    Booking booking,
  ) : this._internal(
          (ref) => findCoaches(
            ref as FindCoachesRef,
            booking,
          ),
          from: findCoachesProvider,
          name: r'findCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findCoachesHash,
          dependencies: FindCoachesFamily._dependencies,
          allTransitiveDependencies:
              FindCoachesFamily._allTransitiveDependencies,
          booking: booking,
        );

  FindCoachesProvider._internal(
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
    FutureOr<List<Coach>> Function(FindCoachesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindCoachesProvider._internal(
        (ref) => create(ref as FindCoachesRef),
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
  AutoDisposeFutureProviderElement<List<Coach>> createElement() {
    return _FindCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindCoachesProvider && other.booking == booking;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, booking.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindCoachesRef on AutoDisposeFutureProviderRef<List<Coach>> {
  /// The parameter `booking` of this provider.
  Booking get booking;
}

class _FindCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<Coach>> with FindCoachesRef {
  _FindCoachesProviderElement(super.provider);

  @override
  Booking get booking => (origin as FindCoachesProvider).booking;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
