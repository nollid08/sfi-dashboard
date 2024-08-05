// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingHash() => r'677dec8cd9ec5ed2c38578cd36e51acb32fcebc6';

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

/// See also [booking].
@ProviderFor(booking)
const bookingProvider = BookingFamily();

/// See also [booking].
class BookingFamily extends Family<AsyncValue<Booking>> {
  /// See also [booking].
  const BookingFamily();

  /// See also [booking].
  BookingProvider call(
    String id,
  ) {
    return BookingProvider(
      id,
    );
  }

  @override
  BookingProvider getProviderOverride(
    covariant BookingProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'bookingProvider';
}

/// See also [booking].
class BookingProvider extends AutoDisposeStreamProvider<Booking> {
  /// See also [booking].
  BookingProvider(
    String id,
  ) : this._internal(
          (ref) => booking(
            ref as BookingRef,
            id,
          ),
          from: bookingProvider,
          name: r'bookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingHash,
          dependencies: BookingFamily._dependencies,
          allTransitiveDependencies: BookingFamily._allTransitiveDependencies,
          id: id,
        );

  BookingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Booking> Function(BookingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingProvider._internal(
        (ref) => create(ref as BookingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Booking> createElement() {
    return _BookingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookingRef on AutoDisposeStreamProviderRef<Booking> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BookingProviderElement extends AutoDisposeStreamProviderElement<Booking>
    with BookingRef {
  _BookingProviderElement(super.provider);

  @override
  String get id => (origin as BookingProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
