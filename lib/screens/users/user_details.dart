import 'package:ebutler_task/screens/users/add_location.dart';
import 'package:ebutler_task/services/service_provider.dart';
import 'package:ebutler_task/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  dynamic User;
   UserDetails({Key? key,required this.User}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _controller = TextEditingController();
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.User['name']),
        backgroundColor: Color.fromRGBO(20, 55, 67, 1),
        actions: [
          IconButton(onPressed: () async {
            await Provider.of<ServiceProvider>(context, listen: false)
                .deleteUser(widget.User['id']).then((res){
                  if(res == true){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted Successfully!')));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));
                  }
            });
          }, icon: Icon(Icons.delete, color: Colors.white,))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserContainer(widget.User),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Locations',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 300,
              width: size.width,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Location List',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            ),

            widget.User['location'] != null ?
            Column(children: widget.User['location'].map<Widget>((item)=>_buildLocationItem(item)).toList(),) : Center(child: Text('No Locations Added'))
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(dynamic item){
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('Location Name'),
              Text(item),
            ],
          ),

          ElevatedButton(onPressed: (){}, child: Text('Delete'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade900))),
        ],
      ),
    );
  }

  Widget _buildUserContainer(dynamic item) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                showEditDialog(()async {
                  await Provider.of<ServiceProvider>(context,listen: false).editUser(widget.User['id'], {
                    'avatar' : _controller.text
                  }).then((res){
                    if(res != false){
                      setState(() {
                        widget.User = res;
                      });
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully!')));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));
                    }
                  });
                },'Avatar URL');
              },
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                  child: item['avatar'] != null ? Image.network(
                    item['avatar'], height: 100.sp,
                    width: 100.sp,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/placeholder.png', height: 100.sp,
                          width: 100.sp,
                          fit: BoxFit.cover,)),) : ClipRRect(child: Image.asset(
                    'assets/images/placeholder.png', height: 100.sp,
                    width: 100.sp,
                    fit: BoxFit.cover,),
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(onTap: () {
                    showEditDialog(()async {
                      await Provider.of<ServiceProvider>(context,listen: false).editUser(widget.User['id'], {
                        'name' : _controller.text
                      }).then((res){
                        if(res != false){
                          setState(() {
                            widget.User = res;
                          });
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully!')));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));
                        }
                      });
                    },'Name');
                },
                    child: Text(item['name'], style: TextStyle(
                        color: Colors.cyan.shade900,
                        fontWeight: FontWeight.w700),)),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    showEditDialog(()async {
                      await Provider.of<ServiceProvider>(context,listen: false).editUser(widget.User['id'], {
                        'description' : _controller.text
                      }).then((res){
                        if(res != false){
                          setState(() {
                            widget.User = res;
                          });
                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully!')));

                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));
                        }
                      });
                    },'Description');
                  },
                  child: SizedBox(width: size.width * 0.55,
                      child: Text(
                        item['description'] != null && item['description'] != ""
                            ? item['description']
                            : 'Salaam! this is my dummy description to take some space you got me',
                        textAlign: TextAlign.start,)),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddLocation(userId: item['id'],locations: item['location']),));
                },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blue.shade900)),
                  child: const Text('Add Location'),)
              ],
            )
          ],
        ),
      ),
    );
  }


  showEditDialog(Function() function,String attr) {
    setState(() {
      _controller.clear();
    });
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter new $attr'
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text('Exit',style: TextStyle(color: Colors.blue.shade900),)),
        ElevatedButton(onPressed: function, child: Text('Update'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade900)),)
      ],
    ),);
  }
}
