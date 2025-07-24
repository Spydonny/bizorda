part of 'company_profile_bloc.dart';

abstract class CompanyProfileEvent {}

class LoadCompanyProfile extends CompanyProfileEvent {
  final String companyId;
  final String token;
  LoadCompanyProfile(this.companyId, this.token);
}

class UpdateCompanyData extends CompanyProfileEvent {
  final Company updatedCompany;
  UpdateCompanyData(this.updatedCompany);
}

class ResetCompanyProfile extends CompanyProfileEvent {}