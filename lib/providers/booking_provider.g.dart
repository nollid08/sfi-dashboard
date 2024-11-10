// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$individualBookingHash() => r'b4d425128713109cdfe11665f1627fc46df600fb';

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

abstract class _$IndividualBooking
    extends BuildlessAutoDisposeStreamNotifier<booking_type.Booking> {
  late final String id;

  Stream<booking_type.Booking> build(
    String id,
  );
}

/// See also [IndividualBooking].
@ProviderFor(IndividualBooking)
const individualBookingProvider = IndividualBookingFamily();

/// See also [IndividualBooking].
class IndividualBookingFamily extends Family<AsyncValue<booking_type.Booking>> {
  /// See also [IndividualBooking].
  const IndividualBookingFamily();

  /// See also [IndividualBooking].
  IndividualBookingProvider call(
    String id,
  ) {
    return IndividualBookingProvider(
      id,
    );
  }

  @override
  IndividualBookingProvider getProviderOverride(
    covariant IndividualBookingProvider provider,
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
  String? get name => r'individualBookingProvider';
}

/// See also [IndividualBooking].
class IndividualBookingProvider extends AutoDisposeStreamNotifierProviderImpl<
    IndividualBooking, booking_type.Booking> {
  /// See also [IndividualBooking].
  IndividualBookingProvider(
    String id,
  ) : this._internal(
          () => IndividualBooking()..id = id,
          from: individualBookingProvider,
          name: r'individualBookingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$individualBookingHash,
          dependencies: IndividualBookingFamily._dependencies,
          allTransitiveDependencies:
              IndividualBookingFamily._allTransitiveDependencies,
          id: id,
        );

  IndividualBookingProvider._internal(
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
  Stream<booking_type.Booking> runNotifierBuild(
    covariant IndividualBooking notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(IndividualBooking Function() create) {
    return ProviderOverride(
      origin: this,
      override: IndividualBookingProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<IndividualBooking,
      booking_type.Booking> createElement() {
    return _IndividualBookingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IndividualBookingProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IndividualBookingRef
    on AutoDisposeStreamNotifierProviderRef<booking_type.Booking> {
  /// The parameter `id` of this provider.
  String get id;
}

class _IndividualBookingProviderElement
    extends AutoDisposeStreamNotifierProviderElement<IndividualBooking,
        booking_type.Booking> with IndividualBookingRef {
  _IndividualBookingProviderElement(super.provider);

  @override
  String get id => (origin as IndividualBookingProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
