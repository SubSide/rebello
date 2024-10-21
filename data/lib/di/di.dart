import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();