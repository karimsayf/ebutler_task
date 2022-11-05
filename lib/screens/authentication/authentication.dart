import 'package:ebutler_task/enums/enums.dart';
import 'package:ebutler_task/models/user.dart';
import 'package:ebutler_task/screens/home.dart';
import 'package:ebutler_task/services/desk_storage.dart';
import 'package:ebutler_task/utils/constants.dart';
import 'package:ebutler_task/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  Auth _currentAuth = Auth.login;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passSecure = true;
  bool _isLoading = false;

  Map _cashedUsers = {};

  @override
  void initState() {
    Provider.of<DeskStorage>(context,listen: false).getUsers().then((users){
      setState(() {
        _cashedUsers = users;
      });
      print(_cashedUsers);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                Color.fromRGBO(20, 55, 67, 1),
          Color.fromRGBO(37, 99, 120, 1),
                ],),),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: largeSpace,
              ),
              Image.asset('assets/logos/ebutler_task_logo.png',color: Colors.white,
                  width: size.width * 70 / 100),
              SizedBox(
                height: 40.sp,
              ),

              const Padding(
                padding :EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.white30),
              ),

              Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          onChanged: _checkCashedUser,
                          validator: validateEmail,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText:  'Enter your Email',
                            contentPadding:  EdgeInsets.all(20),
                            hintStyle:  TextStyle(color: Colors.white),
                            prefixIcon:  Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            errorBorder: InputBorder.none,
                            errorStyle: TextStyle(color: Colors.white),
                            focusedErrorBorder: InputBorder.none,
                            border:  UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: validatePassword,
                          style: const TextStyle(color: Colors.white),
                          obscureText: _passSecure,

                          decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            errorStyle: TextStyle(color: Colors.white),
                            errorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passSecure = !_passSecure;
                                });
                              },
                              icon: Icon(
                                _passSecure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: InputBorder.none,

                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            disabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),

                        SizedBox(
                          height: 100.sp,
                        ),
                        Visibility(visible: _isLoading,child: const Center(child: LinearProgressIndicator(color: Colors.white30,backgroundColor: Colors.transparent,))),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  Size(size.width, 50.sp)),
                              backgroundColor:
                              MaterialStateProperty.all(Colors.white30)),
                          child: Text(
                              _currentAuth == Auth.login ? 'LOGIN' : 'SIGN UP'),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }


  _submit()async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      User user = User(email: _emailController.text,password: _passwordController.text);

      if(_currentAuth == Auth.signUp){
        await Provider.of<DeskStorage>(context,listen: false).addUser(user: user).then((_)async{
          await Provider.of<DeskStorage>(context,listen: false).setAuthenticatedUser(user).then((_){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(),));
          });
        });
      }else{
       _login(user);
      }

      setState(() {
        _isLoading = false;
      });
    }else{
      return ;
    }
  }

  _checkCashedUser(String email){

    if(_cashedUsers.values.any((element) => element['email'] == email)){
      setState(() {
        _currentAuth = Auth.login;
      });
    }else{
      setState(() {
        _currentAuth = Auth.signUp;
      });
    }
  }

  _login(User user)async{
    if(_cashedUsers.values.where((element) => element['email'] == _emailController.text).first['password'] == _passwordController.text){
      await Provider.of<DeskStorage>(context,listen: false).setAuthenticatedUser(user).then((_){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(),));
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong credentials')));
    }
  }


}
