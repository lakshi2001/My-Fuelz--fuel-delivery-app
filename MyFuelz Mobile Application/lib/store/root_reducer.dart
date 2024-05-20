import 'package:myfuelz/store/userDetails/userDetails_reducer.dart';

import 'application_state.dart';


ApplicationState rootReducer(ApplicationState state, action) {
  return ApplicationState(
    // catgeryState: categoryReducer(state.catgeryState, action),
    userDetailsState: userDetailsReducer(state.userDetailsState, action),
  );
}
