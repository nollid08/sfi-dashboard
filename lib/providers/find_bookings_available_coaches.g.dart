// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_bookings_available_coaches.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findBookingsAvailableCoachesHash() =>
    r'0ffe62891f66f68bc0122403f1e441b4272052dc';

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

/// See also [findBookingsAvailableCoaches].
@ProviderFor(findBookingsAvailableCoaches)
const findBookingsAvailableCoachesProvider =
    FindBookingsAvailableCoachesFamily();

/// See also [findBookingsAvailableCoaches].
class FindBookingsAvailableCoachesFamily
    extends Family<AsyncValue<List<CoachRecommendation>>> {
  /// See also [findBookingsAvailableCoaches].
  const FindBookingsAvailableCoachesFamily();

  /// See also [findBookingsAvailableCoaches].
  FindBookingsAvailableCoachesProvider call(
    String bookingId,
  ) {
    return FindBookingsAvailableCoachesProvider(
      bookingId,
    );
  }

  @override
  FindBookingsAvailableCoachesProvider getProviderOverride(
    covariant FindBookingsAvailableCoachesProvider provider,
  ) {
    return call(
      provider.bookingId,
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
  String? get name => r'findBookingsAvailableCoachesProvider';
}

/// See also [findBookingsAvailableCoaches].
class FindBookingsAvailableCoachesProvider
    extends AutoDisposeFutureProvider<List<CoachRecommendation>> {
  /// See also [findBookingsAvailableCoaches].
  FindBookingsAvailableCoachesProvider(
    String bookingId,
  ) : this._internal(
          (ref) => findBookingsAvailableCoaches(
            ref as FindBookingsAvailableCoachesRef,
            bookingId,
          ),
          from: findBookingsAvailableCoachesProvider,
          name: r'findBookingsAvailableCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findBookingsAvailableCoachesHash,
          dependencies: FindBookingsAvailableCoachesFamily._dependencies,
          allTransitiveDependencies:
              FindBookingsAvailableCoachesFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  FindBookingsAvailableCoachesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    FutureOr<List<CoachRecommendation>> Function(
            FindBookingsAvailableCoachesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindBookingsAvailableCoachesProvider._internal(
        (ref) => create(ref as FindBookingsAvailableCoachesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CoachRecommendation>> createElement() {
    return _FindBookingsAvailableCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindBookingsAvailableCoachesProvider &&
        other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindBookingsAvailableCoachesRef
    on AutoDisposeFutureProviderRef<List<CoachRecommendation>> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _FindBookingsAvailableCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<CoachRecommendation>>
    with FindBookingsAvailableCoachesRef {
  _FindBookingsAvailableCoachesProviderElement(super.provider);

  @override
  String get bookingId =>
      (origin as FindBookingsAvailableCoachesProvider).bookingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
