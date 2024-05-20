

import 'package:myfuelz/store/userDetails/userDetails_state.dart';

class ApplicationState {
  //final CategoryState catgeryState;
  final UserDetailsState userDetailsState;
  

  ApplicationState({
    // required this.catgeryState,
    required this.userDetailsState,
  
  });

  factory ApplicationState.initial() {
    return ApplicationState(
      userDetailsState: UserDetailsState.initial(),
      
    );
  }
}
