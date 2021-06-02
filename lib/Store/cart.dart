import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: Icon(Icons.shopping_cart,color: Colors.pink,),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  }
              ),
              Positioned(
                child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 6.0,
                      child: Consumer<CartItemCounter>(
                        builder: (context,counter, _){
                          return Text (
                            counter.count.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    )

                  ],
                ),
              )
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
                itemCount: 2,

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

                    Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                        icon: Icon(Icons.remove_shopping_cart, color: Colors.pinkAccent,),
                        onPressed: ()
                        {
                          addItemToCart(model.shortInfo, context);
                        },
                      )
                          : IconButton(
                        icon: Icon(Icons.delete, color: Colors.pinkAccent,),
                      ),
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



bool checkItemInCart(String shortInfoAsID)
{
  if(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsID))
      {return true;}
  else
  return false;

}

void addItemToCart(String shortInfoAsID, BuildContext context)
{
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.remove(shortInfoAsID);

  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: tempCartList,
  }).then((v){
    Fluttertoast.showToast(msg: "Successfully.");
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);

  }
);
}


