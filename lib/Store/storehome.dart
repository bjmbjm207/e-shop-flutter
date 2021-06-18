import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          title: Text(
            "UET e-Shop",
            style: TextStyle(
            fontSize: 55.0,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
          centerTitle:  true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.upload_sharp,color: Colors.pink,),
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c) => UploadPage());
                      Navigator.pushReplacement(context, route);
                    }
                ),

              ],
            )
          ],

      ),
        drawer: MyDrawer(
        ),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
              builder: (context, dataSnapshot)
              {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child:  Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context,index)
                    {
                      ItemModel model= ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                      return sourceInfo(model, context);
                    },
                  itemCount: dataSnapshot.data.docs.length,

                );
              },
            ),
          ],
        ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: ()
    {
      Route route= MaterialPageRoute(builder: (c)=> ProductPage(itemModel : model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Text(model.title, style: TextStyle(color:Colors.black,fontSize: 14.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.shortInfo, style: TextStyle(color:Colors.black54,fontSize: 12.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink,
                          ),
                          alignment: Alignment.topLeft,
                          width: 40.0,
                          height: 43.0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "50%", style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  "OFF", style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"Origional Price: VND ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    (model.price + model.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"New Price: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "VND ",
                                    style: TextStyle(color: Colors.red,fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Flexible(
                        child: Container(),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String shortInfoAsID, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context)
{
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);

  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
  .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
  .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to Cart, Successfully.");
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
