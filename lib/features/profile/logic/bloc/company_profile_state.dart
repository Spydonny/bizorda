part of 'company_profile_bloc.dart';


abstract class CompanyProfileState extends Equatable {
  const CompanyProfileState();
}

class CompanyProfileInitial extends CompanyProfileState {
  @override
  List<Object?> get props => [];
}
class CompanyProfileLoading extends CompanyProfileState {
  @override
  List<Object?> get props => [];
}

class CompanyProfileLoaded extends CompanyProfileState {
  final Company company;
  final List<Post> posts;
  const CompanyProfileLoaded({required this.company, required this.posts});

  @override
  List<Object?> get props => [company, posts];
}

class CompanyProfileError extends CompanyProfileState {
  final String message;
  const CompanyProfileError(this.message);

  @override
  List<Object?> get props => [message];
}