import 'package:ffapp/components/figure_store_item.dart';
import 'package:ffapp/components/figure_store_skin_item.dart';
import 'package:ffapp/main.dart';
import 'package:ffapp/pages/home/store.dart';
import 'package:ffapp/services/auth.dart';
import 'package:ffapp/services/routes.pb.dart' as Routes;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';



class SkinViewer extends StatefulWidget {
  final List<Routes.Skin> listOfSkins;
  final List<Routes.FigureInstance> listOfFigureInstances;
  final List<Routes.SkinInstance> listOfSkinInstances;
  final figureName;

  SkinViewer({required this.listOfSkins, required this.listOfSkinInstances, required this.figureName, required this.listOfFigureInstances});

  @override
  _SkinViewerState createState() => _SkinViewerState();
}

class _SkinViewerState extends State<SkinViewer> {
  late AuthService auth;
  late UserModel userModel;
  
  void initState() {
    super.initState();
    auth = Provider.of<AuthService>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);

  }

  void showOverlayAlert(BuildContext context, String message, MaterialColor color, int offset) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: MediaQuery.sizeOf(context).width / 2 - offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }

  void viewSkin(BuildContext context, String skinName) {
  }

  void equipSkin(BuildContext context, String figureName, String skinName) {

    Provider.of<FigureInstancesProvider>(context, listen: false).setFigureInstanceCurSkin(figureName, skinName);
    auth.updateFigureInstance(Routes.FigureInstance(figureName: figureName, curSkin: skinName.substring(4), userEmail: userModel.user?.email));
  }

  void purchaseSkin(BuildContext context, int price, String skinSkinName, String figureSkinName, bool owned) async {
    String currency = Provider.of<CurrencyModel>(context, listen: false).currency;
    int cur_currency = int.parse(currency);
    if (cur_currency >= price && owned == false) {
      Provider.of<CurrencyModel>(context, listen: false).setCurrency((cur_currency - price).toString());
      await auth.createSkinInstance(Routes.SkinInstance(userEmail: userModel.user?.email, skinName: skinSkinName, figureName: figureSkinName));
      Provider.of<UserModel>(context, listen: false).user?.currency = Int64(cur_currency - price); 
      await auth.updateUserDBInfo(userModel.user!);
      
      showOverlayAlert(context, "Skin purchased!", Colors.green, 73);
    } else if (owned == true) {
      showOverlayAlert(context, "Skin already owned!", Colors.red, 90);
    } else {
      showOverlayAlert(context, "Not enough currency!", Colors.red, 90);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FigureInstancesProvider>(
        builder: (context, equippedSkin, _) {
          Provider.of<FigureInstancesProvider>(context, listen: true).initializeListOfFigureInstances(widget.listOfFigureInstances);
          return Container(
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
              ),
              items: widget.listOfSkins.where((element) => element.figureName == widget.figureName,).map((skin) {
                bool owned = widget.listOfSkinInstances.any((element) => element.skinName == skin.skinName);
                bool equipped = widget.listOfFigureInstances.any((element) => element.figureName == skin.figureName && element.curSkin == skin.skinName.substring(4));

                return FigureStoreSkinItem(
                  figureName: skin.figureName,
                  skinName: skin.skinName,
                  onViewSkin: (context, figureName) => viewSkin(context, figureName),
                  photoPath: "${skin.figureName}/${skin.figureName}_${skin.skinName}_evo0_cropped_happy",
                  itemPrice: skin.price,
                  onPurchaseSkin: (context, price, skinSkinName, figureSkinName, owned) => purchaseSkin(context, skin.price, skin.skinName, skin.figureName, owned),
                  onEquipSkin: (context, figureName, skinName) => equipSkin(context, figureName, skinName),
                  owned: owned,
                  equipped: equipped,
                );
              }).toList(),
            ),
          );
        },
      );
  }
}