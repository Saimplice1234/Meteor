import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meteor/repository/repository.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex=0;
  List<String> menu=["Today","Tomorrow","7days"];
  int todayIndex=0;
  final player = AudioPlayer();
  @override
  void initState(){
    GetUserLocation();
    //_init();
    super.initState();
  }
  void _init() async{
    var duration = await player.setAsset('assets/zen.mp3');
    player.play();
  }
  // ignore: non_constant_identifier_names
  Future GetUserLocation() async{
    dynamic ip;
    try{
      var response = await Dio().get("https://api.ipgeolocation.io/ipgeo?apiKey=0e1a3c5babd0431d8bafd3a64b12a602");
      setState(() {
        ip=response.data["ip"];
      });
      GetLocality(ip);

    }catch(e){
      print(e);
    }
  }
  // ignore: non_constant_identifier_names
  Future GetLocality(dynamic ip) async{
    try{
      var response = await Dio().get("https://api.ipgeolocation.io/ipgeo?apiKey=0e1a3c5babd0431d8bafd3a64b12a602&ip=$ip");
      setState(() {
        Repository.Locality=response.data["country_capital"];
      });
      Repository.blocWeather.weatherAPi(Repository.Locality);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    extendBodyBehindAppBar:true,
      resizeToAvoidBottomInset:false,
      body:Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          color: Color(0xff262930),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.only(left: 23, right: 23),
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Color(0xff82828A).withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: TextField(
                    onChanged: (str) {
                      Repository.blocWeather.weatherAPi(str);
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Color(0xffFEFFFD),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 12,bottom:6),
                        child:Icon(
                            Icons.location_pin, color: Colors.white,
                            size: 23),
                      ),
                      hintText: "Type the location name",
                      hintStyle:GoogleFonts.poppins(
                        color: Color(0xffFEFFFD).withOpacity(0.2),
                        fontSize:12
                      ),
                      border: InputBorder.none,

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 34),
            StreamBuilder(
              stream:Repository.blocWeather.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  print(snapshot.data["success"]);
                  if(snapshot.data["success"] == null) {
                    return Container(
                      child: Column(
                        children: [
                          ElasticInDown(
                            child: GestureDetector(
                                child: BoxedIcon(
                                  snapshot.data["current"]["is_day"] ==
                                      "yes"
                                      ? WeatherIcons.day_sunny
                                      : WeatherIcons
                                      .night_clear, color: Colors.white,
                                  size: 43,)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BounceInDown(
                                child: Text(
                                    snapshot.data["current"]["temperature"]
                                        .toInt()
                                        .toString(), style:GoogleFonts.poppins(
                                    color: Color(0xffFEFFFD),
                                    fontSize: 84,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                              Container(
                                child:
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 18.0),
                                      child: Container(width: 7, height: 7,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            border: Border.all(
                                                width: 2,
                                                color: Color(0xff787B84))
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 22.0),
                                      child: Text("C", style:GoogleFonts.poppins(
                                          color: Color(0xff787B84),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(snapshot.data["request"]["query"],
                              style:GoogleFonts.poppins(
                                color: Color(0xffFEFFFD),fontSize:12,fontWeight:FontWeight.w500
                              )),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Feel likes ${snapshot
                                  .data["current"]["feelslike"]}",
                                  style:GoogleFonts.poppins(
                                    color: Color(0xffFEFFFD),fontSize:12
                                  )),
                              SizedBox(width: 6),
                              Text("Observation time ${snapshot
                                  .data["current"]["observation_time"]}",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xffFEFFFD),fontWeight:FontWeight.bold
                                  )),
                            ],
                          ),
                          SizedBox(height: 36),
                          SlideInUp(
                            child: Container(
                              height: 140,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: 7,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        todayIndex = index;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(right: 12,
                                          left: 12,
                                          top: todayIndex == index ? 0 : 16),
                                      decoration: BoxDecoration(
                                        color: todayIndex == index ? Colors
                                            .deepOrangeAccent : Color(
                                            0xff3A3D42),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff1C1D22)
                                                .withOpacity(0.2),
                                            //color of shadow
                                            spreadRadius: 5,
                                            //spread radius
                                            blurRadius: 7,
                                            // blur radius
                                            offset: Offset(
                                                0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Text(getHeader(index),
                                              style:GoogleFonts.poppins(
                                                  color: Color(0xffFEFFFD),
                                                  fontSize:10,
                                                  fontWeight: FontWeight.w500
                                              )),
                                          Transform.scale(
                                              scale: todayIndex == index
                                                  ? 1.3
                                                  : 1,
                                              child: getIcons(index)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              SizedBox(width: 6),
                                              Text(getContent(index, snapshot),
                                                  style:GoogleFonts.poppins(
                                                      color: Color(0xffFEFFFD),
                                                      fontSize: 23,
                                                      fontWeight: FontWeight
                                                          .bold
                                                  )),
                                              showDegree(index),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },),
                            ),
                          )

                        ],
                      ),
                    );
                  }else{
                    return Padding(
                      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/2/2-30),
                      child: Center(child: Text("Please enter correct location",style:GoogleFonts.poppins(color:Colors.white.withOpacity(0.2),fontWeight: FontWeight.bold))),
                    );
                  }
                }else{
                  return Container(
                    padding:EdgeInsets.only(top:MediaQuery.of(context).size.height/2/2),
                    child:Center(
                        child:SpinKitFadingFour(
                            color:Colors.white,size:12
                        )
                    ),
                  );
                }
              },

            ),
          ],
        ),
      ),
      appBar:PreferredSize(
          preferredSize:Size.fromHeight(94),
        child:Padding(
          padding: const EdgeInsets.only(top:44.0,left:12),
          child: Container(
            child:Row(
              children: [
                //Icon(Icons.menu,color:Color(0xff7B7C81)),
                SizedBox(width:10,),
                Text("Meteor",style:GoogleFonts.poppins(
                  color:Color(0xff8F929A),fontWeight:FontWeight.bold,fontSize:12,letterSpacing:1
                )),
                SizedBox(width:MediaQuery.of(context).size.width-200,),
                GestureDetector(
                  onTap:(){
                    Repository.blocWeather.weatherAPi(Repository.Locality);
                  },
                  child:Row(
                    children: [
                      Icon(Icons.map_outlined,color:Colors.orange,),
                      SizedBox(width:1,),
                      Text(Repository.Locality.toString(),style:GoogleFonts.poppins(
                          color:Color(0xff8F929A)
                      )),
                    ],
                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }
  String getContent(int index,AsyncSnapshot<dynamic> snapshot){
     if(index == 0){
       return snapshot.data["current"]["wind_speed"].toString();
     }else if(index == 1){
       return snapshot.data["current"]["wind_degree"].toString();
     }else if(index == 2){
       return snapshot.data["current"]["wind_dir"].toString();
     } else if(index == 3){
       return snapshot.data["current"]["pressure"].toString();
     } else if(index == 4){
       return snapshot.data["current"]["precip"].toString();
     } else if(index == 5){
       return snapshot.data["current"]["humidity"].toString();
     } else if(index == 6){
       return snapshot.data["current"]["cloudcover"].toString();
     }
  }
  String getHeader(int index){
    if(index == 0){
      return "Wind Speed";
    }else if(index == 1){
      return "Wind degree";
    }else if(index == 2){
      return "Wind direction";
    }else if(index == 3){
      return "Pressure";
    }else if(index == 4){
      return "Precip";
    }else if(index == 5){
      return "Humidity";
    }else if(index == 6){
      return "Cloudcover";
    }else{
      return "";
    }
  }
  Widget getIcons(int index){
    if(index == 0){
      return BoxedIcon(WeatherIcons.wind_deg_225,color:Colors.white,size:23,);
    }else if(index == 1){
      return BoxedIcon(WeatherIcons.wind_deg_45,color:Colors.white,size:23,);
    } else if(index == 2){
      return BoxedIcon(WeatherIcons.wind_direction,color:Colors.white,size:23,);
    }else if(index == 3){
      return BoxedIcon(WeatherIcons.thermometer,color:Colors.white,size:23,);
    }else if(index == 4){
      return BoxedIcon(WeatherIcons.gale_warning,color:Colors.white,size:23,);
    }else if(index == 5){
      return BoxedIcon(WeatherIcons.humidity,color:Colors.white,size:23,);
    }else if(index == 6){
      return BoxedIcon(WeatherIcons.cloud,color:Colors.white,size:23,);
    }
  }
  Widget showDegree(int index){
    if(index == 5 || index == 1){
      return Row(
        children: [
          SizedBox(width:2),
          Container(width:7,height:7,
            decoration:BoxDecoration(
                color:Colors.transparent,
                borderRadius:BorderRadius.all(Radius.circular(100)),
                border:Border.all(width:2,color:Colors.white.withOpacity(0.6))
            ),
          ),
        ],
      );
    }else{
      return Container();
    }
  }


}
/*

 */