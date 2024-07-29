// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_sessions_available_coaches.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$findSessionsAvailableCoachesHash() =>
    r'9220e91331126e7418f98b8d2eb0f5df2ca346c4';

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

/// See also [findSessionsAvailableCoaches].
@ProviderFor(findSessionsAvailableCoaches)
const findSessionsAvailableCoachesProvider =
    FindSessionsAvailableCoachesFamily();

/// See also [findSessionsAvailableCoaches].
class FindSessionsAvailableCoachesFamily
    extends Family<AsyncValue<List<CoachRecommendation>>> {
  /// See also [findSessionsAvailableCoaches].
  const FindSessionsAvailableCoachesFamily();

  /// See also [findSessionsAvailableCoaches].
  FindSessionsAvailableCoachesProvider call(
    Session session,
  ) {
    return FindSessionsAvailableCoachesProvider(
      session,
    );
  }

  @override
  FindSessionsAvailableCoachesProvider getProviderOverride(
    covariant FindSessionsAvailableCoachesProvider provider,
  ) {
    return call(
      provider.session,
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
  String? get name => r'findSessionsAvailableCoachesProvider';
}

/// See also [findSessionsAvailableCoaches].
class FindSessionsAvailableCoachesProvider
    extends AutoDisposeFutureProvider<List<CoachRecommendation>> {
  /// See also [findSessionsAvailableCoaches].
  FindSessionsAvailableCoachesProvider(
    Session session,
  ) : this._internal(
          (ref) => findSessionsAvailableCoaches(
            ref as FindSessionsAvailableCoachesRef,
            session,
          ),
          from: findSessionsAvailableCoachesProvider,
          name: r'findSessionsAvailableCoachesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findSessionsAvailableCoachesHash,
          dependencies: FindSessionsAvailableCoachesFamily._dependencies,
          allTransitiveDependencies:
              FindSessionsAvailableCoachesFamily._allTransitiveDependencies,
          session: session,
        );

  FindSessionsAvailableCoachesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.session,
  }) : super.internal();

  final Session session;

  @override
  Override overrideWith(
    FutureOr<List<CoachRecommendation>> Function(
            FindSessionsAvailableCoachesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindSessionsAvailableCoachesProvider._internal(
        (ref) => create(ref as FindSessionsAvailableCoachesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        session: session,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CoachRecommendation>> createElement() {
    return _FindSessionsAvailableCoachesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindSessionsAvailableCoachesProvider &&
        other.session == session;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, session.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindSessionsAvailableCoachesRef
    on AutoDisposeFutureProviderRef<List<CoachRecommendation>> {
  /// The parameter `session` of this provider.
  Session get session;
}

class _FindSessionsAvailableCoachesProviderElement
    extends AutoDisposeFutureProviderElement<List<CoachRecommendation>>
    with FindSessionsAvailableCoachesRef {
  _FindSessionsAvailableCoachesProviderElement(super.provider);

  @override
  Session get session =>
      (origin as FindSessionsAvailableCoachesProvider).session;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
