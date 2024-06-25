import 'dart:convert';

bool isBase64(String data){
  try{
    base64Decode(data);

    return true;
  }catch(e){
    return false;
  }
}

Map<String,dynamic> ? deCodeOrNull(String data){
  try{
    final baseData = utf8.decode(
      base64Decode(data),
    );
    return jsonDecode(baseData);
  }catch(e){
    return null;
  }
}