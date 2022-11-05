import 'package:ebutler_task/screens/users/add_location.dart';
import 'package:ebutler_task/screens/users/add_user.dart';
import 'package:ebutler_task/screens/users/user_details.dart';
import 'package:ebutler_task/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future _getUsers = Provider.of<ServiceProvider>(context,listen: false).getUsers();
  final TextEditingController _searchController = TextEditingController();
  final _scrollcontroller = ScrollController();
  bool _isLoading = false;
  var filterExpression = (element) => true;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _scrollcontroller.addListener(_pagination);
    _fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(20, 55, 67, 1),
                  Color.fromRGBO(37, 99, 120, 1),
                ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.sp,),

           /* IconButton(onPressed: (){
              showDialog(context: context, builder: (context) => AlertDialog(
                content: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/bgs/profile_placeholder.png'),
                        radius: 50,
                      ),
                      SizedBox(height: 10,),
                      Text("Salaam All!"),
                      SizedBox(height: 5,),

                      Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(fontSize: 10)),
                      SizedBox(height: 20,),

                      ListTile(onTap: ()async{

                        await Provider.of<ServiceProvider>(context,listen: false).forgotPassword(FirebaseAuth.instance.currentUser!.email!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.forgotEmailSent)));

                      },title: Text(AppLocalizations.of(context)!.resetPassword),leading: Icon(Icons.lock_reset),),
                      ListTile(onTap: ()async{
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context)!.pushReplacement(MaterialPageRoute(builder: (context) => Authentication(),));
                      },title: Text(AppLocalizations.of(context)!.logOut),leading: Icon(Icons.logout),)

                    ],
                  ),
                ),
              ),);
            }, icon: Icon(Icons.menu,color: Colors.white,)),*/
            Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,bottom: 20,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Icon(Icons.quiz,color: Colors.white,size: 20),
                  const SizedBox(width: 10,),
                  const  Text('Welcome To EButler Task',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100)),
                  if(_isLoading)
                    Transform.scale(scale: 0.5,child: CircularProgressIndicator(color: Colors.white,)),
                  IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddUser(),));
                  }, icon: Icon(Icons.add_box,color: Colors.white,))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                   filterExpression = (element) => element['name'].contains(value);
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Users...',
                  errorStyle: const TextStyle(color: Colors.white),
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
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
            ),
            SizedBox(height: 20.sp,),
            Expanded(
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                margin: const EdgeInsets.symmetric(horizontal:10),
                child:  ListView(
                  controller: _scrollcontroller,
                    children: Provider.of<ServiceProvider>(context).fetchedUsers.where(filterExpression).map<Widget>((item)=>_buildUserContainer(item)).toList()
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _fetchUsers()async{
    await Provider.of<ServiceProvider>(context,listen: false).getUsers().then((data)async{
      setState(() {
        Provider.of<ServiceProvider>(context,listen: false).fetchedUsers.addAll(data);
        _isLoading = false;
      });
    });
  }

  void _pagination() {
    if ((_scrollcontroller.position.pixels ==
        _scrollcontroller.position.maxScrollExtent)) {
      setState(() {
        _isLoading = true;
        Provider.of<ServiceProvider>(context,listen: false).page += 1;
        _fetchUsers();
      });
    }
  }

  Widget _buildUserContainer(dynamic item){
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetails(User: item),));
      },
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(10),child: item['avatar'] != null ?Image.network(item['avatar'] ,height: 100.sp,width: 100.sp,fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.asset('assets/images/placeholder.png',height: 100.sp,width: 100.sp,fit: BoxFit.cover,)),) : ClipRRect(child: Image.asset('assets/images/placeholder.png',height: 100.sp,width: 100.sp,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(10))) ,
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(item['name'],style: TextStyle(color: Colors.cyan.shade900,fontWeight: FontWeight.w700),),
                  const SizedBox(height: 10,),
                  SizedBox(width: size.width * 0.55,child: Text( item['description']  != null && item['description'] != "" ? item['description']: 'Salaam! this is my dummy description to take some space you got me',textAlign: TextAlign.start,)),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddLocation(userId: item['id'],locations: item['location']),));
                  },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade900)),
                    child: const Text('Add Location'),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
