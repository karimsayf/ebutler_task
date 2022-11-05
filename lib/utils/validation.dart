String? validateEmail(String? val){
  if(val!.isEmpty){
    return 'Email is required';
  }else if(!val.contains('@')){
    return 'Enter your Email correctly';
  }else{
    return null;
  }
}

String? validatePassword(String? val){
  if(val!.isEmpty){
    return 'Password is required';
  }else if(val.length < 6 ){
    return 'Password is too weak';
  }else{
    return null;
  }
}