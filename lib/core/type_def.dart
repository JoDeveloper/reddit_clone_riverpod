import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';

typedef FutureEither<T> = Future<Either<Failer, T>>;
typedef FutureVoid = Future<Either<Failer,void>>;
