// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleClientHash() => r'acbbd59303bb751409f414be5af545860d57da31';

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

abstract class _$SingleClient extends BuildlessStreamNotifier<Client> {
  late final String clientId;

  Stream<Client> build(
    String clientId,
  );
}

/// See also [SingleClient].
@ProviderFor(SingleClient)
const singleClientProvider = SingleClientFamily();

/// See also [SingleClient].
class SingleClientFamily extends Family<AsyncValue<Client>> {
  /// See also [SingleClient].
  const SingleClientFamily();

  /// See also [SingleClient].
  SingleClientProvider call(
    String clientId,
  ) {
    return SingleClientProvider(
      clientId,
    );
  }

  @override
  SingleClientProvider getProviderOverride(
    covariant SingleClientProvider provider,
  ) {
    return call(
      provider.clientId,
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
  String? get name => r'singleClientProvider';
}

/// See also [SingleClient].
class SingleClientProvider
    extends StreamNotifierProviderImpl<SingleClient, Client> {
  /// See also [SingleClient].
  SingleClientProvider(
    String clientId,
  ) : this._internal(
          () => SingleClient()..clientId = clientId,
          from: singleClientProvider,
          name: r'singleClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleClientHash,
          dependencies: SingleClientFamily._dependencies,
          allTransitiveDependencies:
              SingleClientFamily._allTransitiveDependencies,
          clientId: clientId,
        );

  SingleClientProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clientId,
  }) : super.internal();

  final String clientId;

  @override
  Stream<Client> runNotifierBuild(
    covariant SingleClient notifier,
  ) {
    return notifier.build(
      clientId,
    );
  }

  @override
  Override overrideWith(SingleClient Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleClientProvider._internal(
        () => create()..clientId = clientId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clientId: clientId,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<SingleClient, Client> createElement() {
    return _SingleClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleClientProvider && other.clientId == clientId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clientId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SingleClientRef on StreamNotifierProviderRef<Client> {
  /// The parameter `clientId` of this provider.
  String get clientId;
}

class _SingleClientProviderElement
    extends StreamNotifierProviderElement<SingleClient, Client>
    with SingleClientRef {
  _SingleClientProviderElement(super.provider);

  @override
  String get clientId => (origin as SingleClientProvider).clientId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
