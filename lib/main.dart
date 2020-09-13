
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserCartBloc.dart';
import 'package:picknprint/src/bloc/events/ApplicationDataEvents.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserCartStates.dart';
import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';


ApplicationDataBloc appBloc = ApplicationDataBloc(ApplicationDataLoadingState());
AuthenticationBloc authenticationBloc = AuthenticationBloc(AuthenticationInitiated());
UserCartBloc cartBloc = UserCartBloc(UserCartLoading());

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  appBloc.add(LoadApplicationData());
  authenticationBloc.add(AuthenticateUser());
  Constants.CURRENT_LOCALE = "ar";


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black12,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light
  ));


  runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/locales',
        useOnlyLangCode: true,
        saveLocale: false,
        startLocale: Locale('ar'),
        fallbackLocale: Locale('ar'),
        child: AppEntrance(),
      ),);

}

class AppEntrance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: appBloc),
        BlocProvider.value(value: authenticationBloc),
        BlocProvider.value(value: cartBloc),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
