import 'package:rebello/di/di.config.dart';
import 'package:domain/di.dart' as domain;
import 'package:data/di.dart' as data;
import 'package:presentation/di.dart' as presentation;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
    initializerName: 'init', preferRelativeImports: true, asExtension: true)
void configureDependencies() {
  domain.configureModuleDependencies(getIt);
  data.configureModuleDependencies(getIt);
  presentation.configureModuleDependencies(getIt);
  getIt.init();
}