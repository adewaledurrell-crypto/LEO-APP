/// Résultat générique pour les opérations asynchrones
sealed class Result<T> {
  const Result();

  /// Vérifier si le résultat est un succès
  bool get isSuccess => this is Success;

  /// Vérifier si le résultat est une erreur
  bool get isError => this is Error;

  /// Mapper le résultat
  Result<R> map<R>(R Function(T) f) {
    return switch (this) {
      Success(data: final data) => Success(f(data)),
      Error(exception: final e) => Error(e),
    };
  }

  /// Récupérer les données ou null
  T? getOrNull() {
    return switch (this) {
      Success(data: final data) => data,
      Error() => null,
    };
  }

  /// Récupérer l'exception ou null
  Exception? getExceptionOrNull() {
    return switch (this) {
      Success() => null,
      Error(exception: final e) => e,
    };
  }

  /// Exécuter une fonction sur succès
  void onSuccess(void Function(T) f) {
    if (this is Success) {
      f((this as Success<T>).data);
    }
  }

  /// Exécuter une fonction sur erreur
  void onError(void Function(Exception) f) {
    if (this is Error) {
      f((this as Error<T>).exception);
    }
  }
}

/// Résultat de succès
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

/// Résultat d'erreur
final class Error<T> extends Result<T> {
  final Exception exception;

  const Error(this.exception);

  @override
  String toString() => 'Error($exception)';
}

/// Extension utile pour Future
extension ResultX<T> on Future<Result<T>> {
  /// Attendre le résultat et récupérer les données
  Future<T?> getOrNull() async {
    return (await this).getOrNull();
  }

  /// Attendre le résultat et récupérer l'exception
  Future<Exception?> getExceptionOrNull() async {
    return (await this).getExceptionOrNull();
  }
}
