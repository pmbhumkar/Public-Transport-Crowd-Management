import 'package:flutter/material.dart';
import 'package:maptrack/pages/bus_time_view.dart';

class SearchLanding extends StatelessWidget {
  Map<String, IconData> favourites = {
    "Home": Icons.home,
    "Work": Icons.work,
  };
  final locController = TextEditingController();

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BusTimeList(destination: locController.text),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Image.asset(
      //     "assets/bus_transit.jpg",
      //     fit: BoxFit.cover,
      //     height: 200,
      //     ),
      //   automaticallyImplyLeading: false,

      // ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // automaticallyImplyLeading: false,
                expandedHeight: 300.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                            // padding: EdgeInsets.only(bottom: 10),
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 10)),
                                SizedBox(
                                  width: 170,
                                  child: TextField(
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 15),
                                      hintText: "Where do you want to go",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    controller: locController,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Colors.amber,
                                  child: IconButton(
                                    // color: Colors.amber,
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => BusTimeList(
                                            destination: locController.text),
                                      ));
                                    },
                                  ),
                                )
                              ],
                            ))),
                    background: Image.asset(
                      "assets/bus_wallpaper.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 400,
                  color: Colors.grey[300],
                  child: Stack(
                    children: <Widget>[
                      Text("Favourites"),
                      Positioned(
                        right: 10,
                        child: InkWell(
                          child: Text(
                            "ADD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              new Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: favourites.keys.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          color: Colors.grey[200],
                          child: ListTile(
                            leading: Icon(
                              favourites[favourites.keys.elementAt(i)],
                              color: Colors.black,
                            ),
                            title: Text(
                              favourites.keys.elementAt(i),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
          // body: ListView(
          //   children: <Widget>[
          //     Container(
          //       height: 40,
          //       color: Colors.amber[100],
          //       child: Text("Favourites"),
          //     ),
          //   ],
          // )
        ),
      ),
      drawer: Drawer(
          child: Container(
        color: Colors.grey[700],
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Rate us',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Help & Support',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Feedback',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}