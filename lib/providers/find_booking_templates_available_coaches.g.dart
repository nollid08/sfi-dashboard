// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_booking_templates_available_coaches.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findBookingTemplatesAvailableCoachesHash() =>
    r'b1443e049eec218bc618c2e5fea3152be5130151';

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

/// See also [findBookingTemplatesAvailableCoaches].
@ProviderFor(findBookingTemplatesAvailableCoaches)
const findBookingTemplatesAvailableCoachesProvider =
    FindBookingTemplatesAvailableCoachesFamily();

/// See also [findBookingTemplatesAvailableCoaches].
class FindBookingTemplatesAvailableCoachesFamily
    extends Family<AsyncValue<List<CoachRecommendation>>> {
  /// See also [findBookingTemplatesAvailableCoaches].
  const FindBookingTemplatesAvailableCoachesFamily();

  /// See also [findBookingTemplatesAvailableCoaches].
  FindBookingTemplatesAvailableCoachesProvider call(
    BookingTemplate bookingTemplate,
  ) {
    return FindBookingTemplatesAvailableCoachesProvider(
      bookingTemplate,
    );
  }

  @override
  FindBookingTemplatesAvailableCoachesProvider getProviderOverride(
    covariant FindBookingTemplatesAvailableCoachesProvider provider,
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
  String? get name => r'findBookingTemplatesAvailableCoachesProvider';
}

/// See also [findBookingTemplatesAvailableCoaches].
class FindBookingTemplatesAvailableCoachesProvider
    extends AutoDisposeFutureProvider<List<CoachRecommendation>> {
  /// See also [findBookingTemplatesAvailableCoaches].
  FindBookingTemplatesAvailableCoachesProvider(
    BookingTemplate bookingTemplate,
  ) : this._internal(
          (ref) => findBookingTemplatesAvailableCoaches(
            ref as FindBookingTemplatesAvailableCoachesRef,
            bookingTemplate,
          ),
          from: findBookingTemplatesAvailableCoachesProvider,
          name: r'findBookingTemplatesAvailableCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findBookingTemplatesAvailableCoachesHash,
          dependencies:
              FindBookingTemplatesAvailableCoachesFamily._dependencies,
          allTransitiveDependencies: FindBookingTemplatesAvailableCoachesFamily
              ._allTransitiveDependencies,
          bookingTemplate: bookingTemplate,
        );

  FindBookingTemplatesAvailableCoachesProvider._internal(
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
    FutureOr<List<CoachRecommendation>> Function(
            FindBookingTemplatesAvailableCoachesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindBookingTemplatesAvailableCoachesProvider._internal(
        (ref) => create(ref as FindBookingTemplatesAvailableCoachesRef),
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
  AutoDisposeFutureProviderElement<List<CoachRecommendation>> createElement() {
    return _FindBookingTemplatesAvailableCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindBookingTemplatesAvailableCoachesProvider &&
        other.bookingTemplate == bookingTemplate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingTemplate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindBookingTemplatesAvailableCoachesRef
    on AutoDisposeFutureProviderRef<List<CoachRecommendation>> {
  /// The parameter `bookingTemplate` of this provider.
  BookingTemplate get bookingTemplate;
}

class _FindBookingTemplatesAvailableCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<CoachRecommendation>>
    with FindBookingTemplatesAvailableCoachesRef {
  _FindBookingTemplatesAvailableCoachesProviderElement(super.provider);

  @override
  BookingTemplate get bookingTemplate =>
      (origin as FindBookingTemplatesAvailableCoachesProvider).bookingTemplate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
