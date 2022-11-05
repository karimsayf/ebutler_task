import 'package:ebutler_task/enums/enums.dart';
import 'package:ebutler_task/models/user.dart';
import 'package:ebutler_task/screens/home.dart';
import 'package:ebutler_task/services/desk_storage.dart';
import 'package:ebutler_task/services/service_provider.dart';
import 'package:ebutler_task/utils/constants.dart';
import 'package:ebutler_task/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailUser = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();
  bool _isLoading = false;


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(30),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.topLeft,child: BackButton(color: Colors.white),),
              ),

              SizedBox(height: largeSpace,),

              Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailUser,
                          validator: validateEmail,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText:  'Enter User Email',
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
                          controller: _imageUrl,
                          validator: validatePassword,
                          style: const TextStyle(color: Colors.white),

                          decoration: InputDecoration(
                            hintText: 'Enter User Avatar URL',
                            errorStyle: TextStyle(color: Colors.white),
                            errorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                            hintStyle: const TextStyle(color: Colors.white),

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
                              'SUBMIT'),
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


        await Provider.of<ServiceProvider>(context,listen: false).addUser(_emailUser.text,_imageUrl.text).then((res)async{
          if(res == true){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Added!')));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));
          }
        });


      setState(() {
        _isLoading = false;
      });
    }else{
      return ;
    }
  }

}
