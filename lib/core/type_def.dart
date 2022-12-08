import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';

/// Defining a type alias for a function that returns a Future of an Either of a Failer and a generic
/// type T.
typedef FutureEither<T> = Future<Either<Failer, T>>;


/// Defining a type alias for a function that returns a Future of an Either of a Failer and a generic
/// type T.
typedef FutureVoid = Future<Either<Failer,void>>;
