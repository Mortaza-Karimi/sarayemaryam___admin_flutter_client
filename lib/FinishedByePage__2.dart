import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'SigninPage.dart';
import 'ConfirmPage.dart';
import 'ShopBagTab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ShopBagList.dart';

void Error(context, text, button_text) {
  final snackBar = SnackBar(
    content: Text(text, textDirection: TextDirection.rtl),
    action: SnackBarAction(
      label: button_text,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0, // Inner padding for SnackBar content.
    ),
    duration: const Duration(milliseconds: 3500),
    behavior: SnackBarBehavior.floating,
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SendKalaValues {
  soroush,
  eitaa,
  whatsapp,
}

SendKalaValues _Ersal = SendKalaValues.eitaa;

class FinishedByePage__2 extends StatefulWidget {
  @override
  _FinishedByePage__2State createState() => _FinishedByePage__2State();
}

class _FinishedByePage__2State extends State<FinishedByePage__2> {
  var usernamecontroller = TextEditingController(text: globals.username);
  var passwordcontroller = TextEditingController(text: globals.password);
  var phonenumbercontroller = TextEditingController(text: globals.phonenumber);
  var eitaa_idcontroller = TextEditingController(text: globals.eitaa_id);
  var addresscontroller = TextEditingController(text: globals.address);
  var post_codecontroller = TextEditingController(text: globals.post_code);

  void finished_bye() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("address") == "") {
      Error(context, "???????? ???????? ?????? ???? ???? ?????? ?????????????? ???????? ???????????? ???????? ????????.",
          "????????");
    }
    if (sharedPreferences.getString("post_code") == "") {
      Error(context,
          "???????? ???? ???????? ?????? ???? ???? ?????? ?????????????? ???????? ???????????? ???????? ????????.", "????????");
    }

    var Ersal;
    var Ersal_amount;
    var Massenger;

    if (globals.Ersal.toString() == "SendKalaValues.tahvil_in_sarayemaryam") {
      Ersal = "?????????? ?????????? ???? ???????? ????????";
      Ersal_amount = "???? ???????? ??????????";
    } else if (globals.Ersal.toString() ==
        "SendKalaValues.ersal_be_mojtama_asatid") {
      Ersal = "?????????? ???? ?????????? ????????????";
      Ersal_amount = "????????????";
    } else if (globals.Ersal.toString() ==
        "SendKalaValues.ersal_be_dakhel_shahr_qom") {
      Ersal = "?????????? ???? ???????? ?????? ????";
      Ersal_amount = "3000 ??????????";
    } else if (globals.Ersal.toString() ==
        "SendKalaValues.ersal_be_pardisan_qom") {
      Ersal = "?????????? ???? ?????????????? ????";
      Ersal_amount = "5000 ??????????";
    } else if (globals.Ersal.toString() ==
        "SendKalaValues.ersal_be_shahrestans") {
      Ersal = "?????????? ???? ?????????????? ????";
      Ersal_amount = "10000 ??????????";
    }

    if (_Ersal.toString() == "SendKalaValues.eitaa") {
      Massenger = "????????";
    } else if (_Ersal.toString() == "SendKalaValues.whatsapp") {
      Massenger = "????????????";
    } else if (_Ersal.toString() == "SendKalaValues.soroush") {
      Massenger = "????????";
    }

    var text = "?????? ???????? : " +
        "\n\n ???????? : " +
        sharedPreferences.getString("eitaa_id") +
        "\n\n?????????? : " +
        sharedPreferences.getString("phonenumber") +
        "\n\n???????? : " +
        sharedPreferences.getString("address") +
        "\n\n???? ???????? : " +
        sharedPreferences.getString("post_code") +
        "\n\n???????? ???????????? ???????? :" +
        Ersal +
        "\n\n?????????? ?????????? ???????? :" +
        Ersal_amount +
        "\n\n???????? ???????????? ???? ?????????? ???????? : " +
        Massenger;
    var url = Uri.http(globals.django_url, globals.send_message_url);
    Response response = await post(url, body: {'text': text});

    url = Uri.http(globals.django_url, globals.get_all_cart_url);
    response = await post(url,
        body: {"user": sharedPreferences.getString("username")});

    List<ShopBagList> _items = [];
    var itemsjson = json.decode(response.body)['result'];
    for (var i in itemsjson) {
      var item = ShopBagList(
        int.parse(i['id']),
        i["name"],
        i["text"],
        i["amount"],
        i["img"],
        i["num"],
        i["number"],
        i['old_num'],
        i['group'],
        i['color'],
        i['size'],
        i['img'],
        i['img'],
        i['img'],
      );
      _items.add(item);
      // globals.shopbagitems = _items;
    }
    for (var j in _items) {
      var remove_num_url = "kala/" + j.group.toString() + "/remove_num";
      print(remove_num_url);

      url = Uri.http(globals.django_url, remove_num_url);
      response = await post(url,
          body: {'name': j.name, 'id': j.id.toString(), 'num': j.num});

      url = Uri.http(globals.django_url, globals.delete_from_cart_url);
      response = await post(url, body: {
        'user': sharedPreferences.getString("username"),
        'name': j.name,
        'amount': j.amount,
        'img': j.img
      });
      print(response.body);
    }

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ShopBagTab()));

    if (Massenger == "????????") {
      _launchURL("https://eitaa.com/salambarf");
    } else if (Massenger == "????????????") {
      _launchURL("https://wa.me/09194517132");
    }
  }

  void storage() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    setState() {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "?????????? ????????",
            style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(children: [
          Container(
            child: Container(
              color: Colors.white,
              child: Container(
                child: Padding(
                    padding: EdgeInsets.all(45),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "???????? ???????? ?????????? ???? ???? ???? ???????????? ???? ???? ???? ?????????? ???????? ???? ???????????? ?????????? ???? ???????????? ????????.",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              RadioListTile<SendKalaValues>(
                                  title: Image.network(
                                    "http://193.176.243.61/media/ir.eitaa.messenger_e6f3a777-cb9b-4cc3-8b98-99c430ba8fec.png",
                                    height: 48,
                                  ),
                                  value: SendKalaValues.eitaa,
                                  groupValue: _Ersal,
                                  onChanged: (SendKalaValues value) {
                                    setState(() {
                                      _Ersal = value;
                                    });
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              RadioListTile<SendKalaValues>(
                                  title: Image.network(
                                    "http://193.176.243.61/media/whatsapp--v1.png",
                                    height: 68,
                                  ),
                                  value: SendKalaValues.whatsapp,
                                  groupValue: _Ersal,
                                  onChanged: (SendKalaValues value) {
                                    setState(() {
                                      _Ersal = value;
                                    });
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              RadioListTile<SendKalaValues>(
                                  title: Image.network(
                                    "http://193.176.243.61/media/mobi.mmdt.ott_512x512.png",
                                    height: 48,
                                  ),
                                  value: SendKalaValues.soroush,
                                  groupValue: _Ersal,
                                  onChanged: (SendKalaValues value) {
                                    setState(() {
                                      _Ersal = value;
                                    });
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60, right: 60),
                            child: Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.green,
                              child: InkWell(
                                onTap: () {
                                  finished_bye();
                                },
                                child: Container(
                                  width: 500,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    "?????????? ???????? ????????",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ])),
              ),
            ),
          )
        ]));
  }
}

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
