class ModeloRespuestaBot {
  String queryText; //texto
  String languageCode; //texto
  String action; //texto
  bool allRequiredParamsPresent; //no cambia
  String fulfillmentText; //texto
  
  ModeloRespuestaBot(
      {this.queryText,
      this.languageCode,
      this.action,
      this.allRequiredParamsPresent,
      this.fulfillmentText,
      });

  ModeloRespuestaBot.fromJson(Map<String, dynamic> json) {
    queryText = json['queryText'];
    languageCode = json['languageCode'];
    action = json['action'];
    allRequiredParamsPresent = json['allRequiredParamsPresent'];
    fulfillmentText = json['fulfillmentText'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queryText'] = this.queryText;
    data['languageCode'] = this.languageCode;
    data['action'] = this.action;
    
    data['allRequiredParamsPresent'] = this.allRequiredParamsPresent;
    data['fulfillmentText'] = this.fulfillmentText;
    
    
    return data;
  }
}

class Parameters {
  String serviceEntity;
  String facturaEntity;

  Parameters({this.serviceEntity, this.facturaEntity});

  Parameters.fromJson(Map<String, dynamic> json) {
    serviceEntity = json['ServiceEntity'];
    facturaEntity = json['FacturaEntity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServiceEntity'] = this.serviceEntity;
    data['FacturaEntity'] = this.facturaEntity;
    return data;
  }
}

class FulfillmentMessages {
  Text text;

  FulfillmentMessages({this.text});

  FulfillmentMessages.fromJson(Map<String, dynamic> json) {
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.text != null) {
      data['text'] = this.text.toJson();
    }
    return data;
  }
}

class Text {
  List<String> text;

  Text({this.text});

  Text.fromJson(Map<String, dynamic> json) {
    text = json['text'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Intent {
  String name;
  String displayName;

  Intent({this.name, this.displayName});

  Intent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['displayName'] = this.displayName;
    return data;
  }
}

