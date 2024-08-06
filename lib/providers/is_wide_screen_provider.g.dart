// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_wide_screen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isWideScreenHash() => r'55e67df8645f9c26a8d493dfa6d0f051f2fe60cb';

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

/// See also [isWideScreen].
@ProviderFor(isWideScreen)
const isWideScreenProvider = IsWideScreenFamily();

/// See also [isWideScreen].
class IsWideScreenFamily extends Family<bool> {
  /// See also [isWideScreen].
  const IsWideScreenFamily();

  /// See also [isWideScreen].
  IsWideScreenProvider call(
    MediaQueryData mqData,
  ) {
    return IsWideScreenProvider(
      mqData,
    );
  }

  @override
  IsWideScreenProvider getProviderOverride(
    covariant IsWideScreenProvider provider,
  ) {
    return call(
      provider.mqData,
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
  String? get name => r'isWideScreenProvider';
}

/// See also [isWideScreen].
class IsWideScreenProvider extends AutoDisposeProvider<bool> {
  /// See also [isWideScreen].
  IsWideScreenProvider(
    MediaQueryData mqData,
  ) : this._internal(
          (ref) => isWideScreen(
            ref as IsWideScreenRef,
            mqData,
          ),
          from: isWideScreenProvider,
          name: r'isWideScreenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isWideScreenHash,
          dependencies: IsWideScreenFamily._dependencies,
          allTransitiveDependencies:
              IsWideScreenFamily._allTransitiveDependencies,
          mqData: mqData,
        );

  IsWideScreenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mqData,
  }) : super.internal();

  final MediaQueryData mqData;

  @override
  Override overrideWith(
    bool Function(IsWideScreenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsWideScreenProvider._internal(
        (ref) => create(ref as IsWideScreenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mqData: mqData,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsWideScreenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsWideScreenProvider && other.mqData == mqData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mqData.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsWideScreenRef on AutoDisposeProviderRef<bool> {
  /// The parameter `mqData` of this provider.
  MediaQueryData get mqData;
}

class _IsWideScreenProviderElement extends AutoDisposeProviderElement<bool>
    with IsWideScreenRef {
  _IsWideScreenProviderElement(super.provider);

  @override
  MediaQueryData get mqData => (origin as IsWideScreenProvider).mqData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
