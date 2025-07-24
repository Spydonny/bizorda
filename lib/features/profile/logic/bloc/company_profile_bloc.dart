import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:talker/talker.dart';
import '../../../feed/data/models/post.dart';
import '../../../feed/data/repos/post_repo.dart';
import '../../../shared/data/models/company.dart';
import '../../../shared/data/repos/company_repo.dart';

part 'company_profile_event.dart';
part 'company_profile_state.dart';

class CompanyProfileBloc extends HydratedBloc<CompanyProfileEvent, CompanyProfileState> {
  CompanyProfileBloc() : super(CompanyProfileInitial()) {
    on<LoadCompanyProfile>(_onLoad);
    on<UpdateCompanyData>(_onUpdate);
    on<ResetCompanyProfile>((event, emit) {
      emit(CompanyProfileInitial());
    });
  }

  Future<void> _onLoad(LoadCompanyProfile event, Emitter<CompanyProfileState> emit) async {
    emit(CompanyProfileLoading());
    try {
      final companyRepo = CompanyRepository();
      final postRepo = PostRepository(token: event.token);

      final company = await companyRepo.getCompanyById(event.companyId);
      final posts = await postRepo.getPostsByCompany(event.companyId);
      emit(CompanyProfileLoaded(company: company, posts: posts));
    } catch (e, st) {
      Talker().handle(e, st, 'Ошибка загрузки профиля компании');
      emit(CompanyProfileError('Не удалось загрузить профиль компании'));
    }
  }

  Future<void> _onUpdate(UpdateCompanyData event, Emitter<CompanyProfileState> emit) async {
    if (state is CompanyProfileLoaded) {
      final current = state as CompanyProfileLoaded;
      final updated = event.updatedCompany;
      emit(CompanyProfileLoaded(company: updated, posts: current.posts));
      try {
        final companyRepo = CompanyRepository();
        await companyRepo.updateCompany(
          companyId: updated.id,
          data: updated.toJson(),
        );
      } catch (e, st) {
        Talker().handle(e, st, 'Ошибка при обновлении компании');
        emit(CompanyProfileError('Ошибка при обновлении данных компании'));
      }
    }
  }


  @override
  CompanyProfileState? fromJson(Map<String, dynamic> json) {
    try {
      final company = Company.fromJson(json['company']);
      final posts = (json['posts'] as List).map((p) => Post.fromJson(p)).toList();
      return CompanyProfileLoaded(company: company, posts: posts);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CompanyProfileState state) {
    if (state is CompanyProfileLoaded) {
      return {
        'company': state.company.toJson(),
        'posts': state.posts.map((p) => p.toJson()).toList(),
      };
    }
    return null;
  }
}

