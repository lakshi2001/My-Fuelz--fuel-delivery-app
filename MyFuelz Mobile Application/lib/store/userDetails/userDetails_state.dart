class UserDetailsState {
  String selectedName = '';
  String selectedPhoneNumber = '';
  String selectedEmail = '';
  String selectedRole = '';
  String selectedUserId = '';
  String selectedTankerName = '';
  String selectedTankerPhoneNumber = '';
  String selectedTankerEmail = '';
  String selectedTankerRole = '';
  String selectedTankerUserId = '';
  String selectedAdd = '';
  String selectedFuelLit = '';
  String selectedStationName = '';
  String selectedDesc = '';
  String selectedStatID = '';
  List<dynamic> token = [];
  List<Map<String, dynamic>> allStations = [];
  String imageURL = '';

  UserDetailsState({
    //required this.selectedcartItem,

    required this.selectedEmail,
    required this.selectedRole,
    required this.selectedName,
    required this.selectedUserId,
    required this.selectedPhoneNumber,
    required this.selectedTankerEmail,
    required this.selectedTankerRole,
    required this.selectedTankerName,
    required this.selectedTankerUserId,
    required this.selectedTankerPhoneNumber,
    required this.selectedAdd,
    required this.selectedFuelLit,
    required this.selectedStationName,
    required this.selectedDesc,
    required this.selectedStatID,
    required this.token,
    required this.allStations,
    required this.imageURL,
  });

  UserDetailsState.fromUserDetailsState(UserDetailsState another) {
    selectedEmail = another.selectedEmail;
    selectedRole = another.selectedRole;
    selectedName = another.selectedName;
    selectedUserId = another.selectedUserId;
    selectedPhoneNumber = another.selectedPhoneNumber;
    selectedTankerEmail = another.selectedTankerEmail;
    selectedTankerRole = another.selectedTankerRole;
    selectedTankerName = another.selectedTankerName;
    selectedTankerUserId = another.selectedTankerUserId;
    selectedTankerPhoneNumber = another.selectedTankerPhoneNumber;
    selectedAdd = another.selectedAdd;
    selectedFuelLit = another.selectedFuelLit;
    selectedStationName = another.selectedStationName;
    selectedDesc = another.selectedDesc;
    selectedStatID = another.selectedStatID;
    token = another.token;
    allStations = another.allStations;
    imageURL = another.imageURL;
  }

  factory UserDetailsState.initial() {
    return UserDetailsState(
      selectedEmail: '',
      selectedName: '',
      selectedRole: '',
      selectedUserId: '',
      selectedPhoneNumber: '',
      selectedTankerEmail: '',
      selectedTankerName: '',
      selectedTankerRole: '',
      selectedTankerUserId: '',
      selectedTankerPhoneNumber: '',
      selectedAdd: '',
      selectedFuelLit: '',
      selectedStationName: '',
      selectedDesc: '',
      selectedStatID: '',
      token: [],
      allStations: [],
      imageURL: '',
    );
  }
}
