import 'userDetails_action.dart';
import 'userDetails_state.dart';

UserDetailsState userDetailsReducer(
    UserDetailsState prevState, dynamic action) {
  UserDetailsState newState = UserDetailsState.fromUserDetailsState(prevState);

  // if (action is CartItem) {
  //   newState.selectedcartItem = action.cartList;
  // }
  if (action is UserDetails) {
    newState.selectedEmail = action.email;
    newState.selectedName = action.name;
    newState.selectedRole = action.role;
    newState.selectedUserId = action.userID;
    newState.selectedPhoneNumber = action.phoneNumber;
  }
  if (action is TankerDetails) {
    newState.selectedTankerEmail = action.email;
    newState.selectedTankerName = action.name;
    newState.selectedTankerRole = action.role;
    newState.selectedTankerUserId = action.userID;
    newState.selectedTankerPhoneNumber = action.phoneNumber;
  }
  if (action is FuelDetails) {
    newState.selectedAdd = action.address;
    newState.selectedFuelLit = action.fuelLit;
    newState.selectedStationName = action.stationName;
    newState.selectedDesc = action.desc;
    newState.selectedStatID = action.statID;
  }

  if (action is AssignToken) {
    newState.token = action.token;
  }
  if (action is FuelStations) {
    newState.allStations = action.stations;
  }

  return newState;
}
