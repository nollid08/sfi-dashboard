// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_coach.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findAvailableCoachesHash() =>
    r'4d2a8d9bbbcddac2eb20415f6aad9347525310a4';

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
    BookingTemplate bookingTemplate,
  ) {
    return FindAvailableCoachesProvider(
      bookingTemplate,
    );
  }

  @override
  FindAvailableCoachesProvider getProviderOverride(
    covariant FindAvailableCoachesProvider provider,
  ) {
    return call(
      provider.bookingTemplate,
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
    BookingTemplate bookingTemplate,
  ) : this._internal(
          (ref) => findAvailableCoaches(
            ref as FindAvailableCoachesRef,
            bookingTemplate,
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
          bookingTemplate: bookingTemplate,
        );

  FindAvailableCoachesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingTemplate,
  }) : super.internal();

  final BookingTemplate bookingTemplate;

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
        bookingTemplate: bookingTemplate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CoachTravelEstimate>> createElement() {
    return _FindAvailableCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindAvailableCoachesProvider &&
        other.bookingTemplate == bookingTemplate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingTemplate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindAvailableCoachesRef
    on AutoDisposeFutureProviderRef<List<CoachTravelEstimate>> {
  /// The parameter `bookingTemplate` of this provider.
  BookingTemplate get bookingTemplate;
}

class _FindAvailableCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<CoachTravelEstimate>>
    with FindAvailableCoachesRef {
  _FindAvailableCoachesProviderElement(super.provider);

  @override
  BookingTemplate get bookingTemplate =>
      (origin as FindAvailableCoachesProvider).bookingTemplate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
