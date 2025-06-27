part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();
}

final class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}
