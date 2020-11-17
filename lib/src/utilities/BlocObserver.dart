import 'package:bloc/bloc.dart';

class BlocLogObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
  }



  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("**********************************************************");
    print("Bloc $bloc Is Moving From ${transition.currentState} To ${transition.nextState} Because ${transition.event} Dispatched");
    print("**********************************************************");
    super.onTransition(bloc, transition);
  }
}
