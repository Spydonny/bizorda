part of 'company_bloc.dart';

sealed class CompanyState extends Equatable {
  const CompanyState();
}

final class CompanyInitial extends CompanyState {
  @override
  List<Object> get props => [];
}

final class CompanyFromInput extends CompanyState {


  @override
  List<Object> get props => [];
}

final class CompanyLoaded extends CompanyState {
  final Company company;

  const CompanyLoaded(this.company);

  @override
  List<Object> get props => [company];
}
