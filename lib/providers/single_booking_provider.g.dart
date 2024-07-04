// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleBookingHash() => r'0fa44d3307ace9344f797b3c2b6676caa34e459a';

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

abstract class _$SingleBooking
    extends BuildlessAutoDisposeStreamNotifier<Booking> {
  late final String id;

  Stream<Booking> build(
    String id,
  );
}

/// See also [SingleBooking].
@ProviderFor(SingleBooking)
const singleBookingProvider = SingleBookingFamily();

/// See also [SingleBooking].
class SingleBookingFamily extends Family<AsyncValue<Booking>> {
  /// See also [SingleBooking].
  const SingleBookingFamily();

  /// See also [SingleBooking].
  SingleBookingProvider call(
    String id,
  ) {
    return SingleBookingProvider(
      id,
    );
  }

  @override
  SingleBookingProvider getProviderOverride(
    covariant SingleBookingProvider provider,
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
  String? get name => r'singleBookingProvider';
}

/// See also [SingleBooking].
class SingleBookingProvider
    extends AutoDisposeStreamNotifierProviderImpl<SingleBooking, Booking> {
  /// See also [SingleBooking].
  SingleBookingProvider(
    String id,
  ) : this._internal(
          () => SingleBooking()..id = id,
          from: singleBookingProvider,
          name: r'singleBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleBookingHash,
          dependencies: SingleBookingFamily._dependencies,
          allTransitiveDependencies:
              SingleBookingFamily._allTransitiveDependencies,
          id: id,
        );

  SingleBookingProvider._internal(
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
  Stream<Booking> runNotifierBuild(
    covariant SingleBooking notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(SingleBooking Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleBookingProvider._internal(
        () => create()..id = id,
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
  AutoDisposeStreamNotifierProviderElement<SingleBooking, Booking>
      createElement() {
    return _SingleBookingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleBookingProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SingleBookingRef on AutoDisposeStreamNotifierProviderRef<Booking> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SingleBookingProviderElement
    extends AutoDisposeStreamNotifierProviderElement<SingleBooking, Booking>
    with SingleBookingRef {
  _SingleBookingProviderElement(super.provider);

  @override
  String get id => (origin as SingleBookingProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
