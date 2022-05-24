class CityModel {
  CityModel({
    required this.states,
  });
  late final List<States> states;

  CityModel.fromJson(Map<String, dynamic> json){
    states = List.from(json['states']).map((e)=>States.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['states'] = states.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class States {
  States({
    required this.state,
    required this.districts,
  });
  late final String state;
  late final List<String> districts;

  States.fromJson(Map<String, dynamic> json){
    state = json['state'];
    districts = List.castFrom<dynamic, String>(json['districts']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['state'] = state;
    _data['districts'] = districts;
    return _data;
  }
}