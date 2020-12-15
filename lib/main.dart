import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:picknprint/src/bloc/blocs/ApplicationDataBloc.dart';
import 'package:picknprint/src/bloc/blocs/AuthenticationBloc.dart';
import 'package:picknprint/src/bloc/blocs/UserBloc.dart';

import 'package:picknprint/src/bloc/events/ApplicationDataEvents.dart';
import 'package:picknprint/src/bloc/events/AuthenticationEvents.dart';
import 'package:picknprint/src/bloc/states/ApplicationDataState.dart';
import 'package:picknprint/src/bloc/states/AuthenticationStates.dart';
import 'package:picknprint/src/bloc/states/UserBlocStates.dart';

import 'package:picknprint/src/resources/Constants.dart';
import 'package:picknprint/src/resources/Resources.dart';
import 'package:picknprint/src/ui/screens/HomeScreen.dart';
import 'package:picknprint/src/ui/screens/confirmation_screens/OrderConfirmationScreen.dart';
import 'package:picknprint/src/utilities/BlocObserver.dart';



ApplicationDataBloc appBloc = ApplicationDataBloc(ApplicationDataLoadingState());
AuthenticationBloc authenticationBloc = AuthenticationBloc(AuthenticationInitiated());
UserBloc userBloc ;
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocLogObserver();
  userBloc = UserBloc(UserDataLoadingState() , authenticationBloc);
  appBloc.add(LoadApplicationData());
  authenticationBloc.add(AuthenticateUser());
  Constants.CURRENT_LOCALE = "en";


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
          saveLocale: true,
          // startLocale: Locale('en'),
          fallbackLocale: Locale('en'),
          child: AppEntrance(),
        ),
  );


}



class AppEntrance extends StatefulWidget {
  @override
  _AppEntranceState createState() => _AppEntranceState();
}

class _AppEntranceState extends State<AppEntrance> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: appBloc),
        BlocProvider.value(value: authenticationBloc),
        BlocProvider.value(value: userBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  HomeScreen(),
        theme: ThemeData(
          fontFamily: EasyLocalization.of(context).locale.languageCode == 'en'
            ? Resources.english_font_family
            : Resources.arabic_font_family,
        ),
      ),
    );
  }
}


