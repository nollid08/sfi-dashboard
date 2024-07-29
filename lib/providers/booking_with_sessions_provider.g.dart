// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_with_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleBookingWithSessionsHash() =>
    r'5eb928017ca02b7c6b2080f5d951d63f90beda98';

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

abstract class _$SingleBookingWithSessions
    extends BuildlessAutoDisposeStreamNotifier<BookingWithSessions> {
  late final String id;

  Stream<BookingWithSessions> build(
    String id,
  );
}

/// See also [SingleBookingWithSessions].
@ProviderFor(SingleBookingWithSessions)
const singleBookingWithSessionsProvider = SingleBookingWithSessionsFamily();

/// See also [SingleBookingWithSessions].
class SingleBookingWithSessionsFamily
    extends Family<AsyncValue<BookingWithSessions>> {
  /// See also [SingleBookingWithSessions].
  const SingleBookingWithSessionsFamily();

  /// See also [SingleBookingWithSessions].
  SingleBookingWithSessionsProvider call(
    String id,
  ) {
    return SingleBookingWithSessionsProvider(
      id,
    );
  }

  @override
  SingleBookingWithSessionsProvider getProviderOverride(
    covariant SingleBookingWithSessionsProvider provider,
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
  String? get name => r'singleBookingWithSessionsProvider';
}

/// See also [SingleBookingWithSessions].
class SingleBookingWithSessionsProvider
    extends AutoDisposeStreamNotifierProviderImpl<SingleBookingWithSessions,
        BookingWithSessions> {
  /// See also [SingleBookingWithSessions].
  SingleBookingWithSessionsProvider(
    String id,
  ) : this._internal(
          () => SingleBookingWithSessions()..id = id,
          from: singleBookingWithSessionsProvider,
          name: r'singleBookingWithSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleBookingWithSessionsHash,
          dependencies: SingleBookingWithSessionsFamily._dependencies,
          allTransitiveDependencies:
              SingleBookingWithSessionsFamily._allTransitiveDependencies,
          id: id,
        );

  SingleBookingWithSessionsProvider._internal(
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
  Stream<BookingWithSessions> runNotifierBuild(
    covariant SingleBookingWithSessions notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(SingleBookingWithSessions Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleBookingWithSessionsProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<SingleBookingWithSessions,
      BookingWithSessions> createElement() {
    return _SingleBookingWithSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleBookingWithSessionsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SingleBookingWithSessionsRef
    on AutoDisposeStreamNotifierProviderRef<BookingWithSessions> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SingleBookingWithSessionsProviderElement
    extends AutoDisposeStreamNotifierProviderElement<SingleBookingWithSessions,
        BookingWithSessions> with SingleBookingWithSessionsRef {
  _SingleBookingWithSessionsProviderElement(super.provider);

  @override
  String get id => (origin as SingleBookingWithSessionsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
