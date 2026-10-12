import 'package:flutter/material.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Success] with a value of type [T]
/// or a [Failure] with an error of type [E].
///
/// Use [Result.success] to create a successful result with a value of type [T].
/// Use [Result.failure] to create an error result with a value of type [E].
sealed class Result<T, E> {
  /// Standard constructor.
  const Result();

  /// Creates an instance of Result containing a value.
  factory Result.success(T value) => Success(value);

  /// Create an instance of Result containing an error.
  factory Result.failure(E error) => Failure(error);
}

/// Subclass of Result for values.
@immutable
final class Success<T, E> extends Result<T, E> {
  /// Standard constructor.
  const Success(this.value);

  /// Returned value in result.
  final T value;
}

/// Subclass of Result for errors.
@immutable
final class Failure<T, E> extends Result<T, E> {
  /// Standard constructor.
  const Failure(this.error);

  /// Returned error in result.
  final E error;
}
