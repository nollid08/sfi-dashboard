// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingsHash() => r'e9c741ee1dd3a114f308a9ea9af6851bf88e80c0';

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

abstract class _$Bookings
    extends BuildlessAutoDisposeStreamNotifier<List<Booking>> {
  late final IList<Coach> coaches;

  Stream<List<Booking>> build(
    IList<Coach> coaches,
  );
}

/// See also [Bookings].
@ProviderFor(Bookings)
const bookingsProvider = BookingsFamily();

/// See also [Bookings].
class BookingsFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [Bookings].
  const BookingsFamily();

  /// See also [Bookings].
  BookingsProvider call(
    IList<Coach> coaches,
  ) {
    return BookingsProvider(
      coaches,
    );
  }

  @override
  BookingsProvider getProviderOverride(
    covariant BookingsProvider provider,
  ) {
    return call(
      provider.coaches,
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
  String? get name => r'bookingsProvider';
}

/// See also [Bookings].
class BookingsProvider
    extends AutoDisposeStreamNotifierProviderImpl<Bookings, List<Booking>> {
  /// See also [Bookings].
  BookingsProvider(
    IList<Coach> coaches,
  ) : this._internal(
          () => Bookings()..coaches = coaches,
          from: bookingsProvider,
          name: r'bookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingsHash,
          dependencies: BookingsFamily._dependencies,
          allTransitiveDependencies: BookingsFamily._allTransitiveDependencies,
          coaches: coaches,
        );

  BookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coaches,
  }) : super.internal();

  final IList<Coach> coaches;

  @override
  Stream<List<Booking>> runNotifierBuild(
    covariant Bookings notifier,
  ) {
    return notifier.build(
      coaches,
    );
  }

  @override
  Override overrideWith(Bookings Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookingsProvider._internal(
        () => create()..coaches = coaches,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coaches: coaches,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<Bookings, List<Booking>>
      createElement() {
    return _BookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsProvider && other.coaches == coaches;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coaches.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookingsRef on AutoDisposeStreamNotifierProviderRef<List<Booking>> {
  /// The parameter `coaches` of this provider.
  IList<Coach> get coaches;
}

class _BookingsProviderElement
    extends AutoDisposeStreamNotifierProviderElement<Bookings, List<Booking>>
    with BookingsRef {
  _BookingsProviderElement(super.provider);

  @override
  IList<Coach> get coaches => (origin as BookingsProvider).coaches;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
