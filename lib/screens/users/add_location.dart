import 'package:ebutler_task/services/service_provider.dart';
import 'package:ebutler_task/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddLocation extends StatefulWidget {
  String userId;
  List locations;
  AddLocation({Key? key,required this.userId,required this.locations}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  late GoogleMapController mapController;
  final TextEditingController _controller = TextEditingController();
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool _maps = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: largeSpace,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Maps'),
                SizedBox(width: 10,),
                CupertinoSwitch(value: _maps, onChanged: (value) {
                  setState(() {
                    _maps = !_maps;
                  });
                },),
                SizedBox(width: 10,),
                Text('LatLng'),
              ],
            ),
            SizedBox(height: 30.sp,),


            if(_maps)
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
            if(!_maps)
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),

                  decoration: const InputDecoration(
                    hintText: 'Enter Lat Lang',
                    errorStyle: TextStyle(color: Colors.black),
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: const TextStyle(color: Colors.black),

                    focusedErrorBorder: InputBorder.none,

                    border:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    disabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),

            SizedBox(height: 30.sp,),
            ElevatedButton(onPressed: ()async{
              setState(() {
                widget.locations.add(_controller.text);
              });
              await Provider.of<ServiceProvider>(context,listen: false).addLocation(widget.userId,widget.locations  ).then((res){
                if(res == true){
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added Successfully!')));

                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed!')));

                }
              });
            },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade900)), child: Text('Add'),)
          ],
        ),
      ),
    );
  }
}
