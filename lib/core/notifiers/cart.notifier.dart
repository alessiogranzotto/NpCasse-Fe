import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/initial_context.dart';
import 'package:np_casse/core/api/cart.api.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class CartNotifier with ChangeNotifier {
  final CartAPI cartAPI = CartAPI();

  CartModel currentCartModel = CartModel.empty();
  // int _nrProductInCart = 0;
  // int _nrProductTypeInCart = 0;
  // double _totalCartMoney = 0;
  // int get nrProductInCart => _nrProductInCart;
  // int get nrProductTypeInCart => _nrProductTypeInCart;

  late ValueNotifier<double> subTotalCartMoney = ValueNotifier(0);
  late ValueNotifier<double> totalCartMoney = ValueNotifier(0);
  late ValueNotifier<int> totalCartProduct = ValueNotifier(0);
  late ValueNotifier<int> totalCartProductType = ValueNotifier(0);

  setCart(CartModel cartModel) {
    int _nrProductInCart = 0;
    int _nrProductTypeInCart = 0;
    double _subTotalCartMoney = 0;
    currentCartModel = cartModel;
    _nrProductTypeInCart = cartModel.cartProducts.length;
    for (var element in cartModel.cartProducts) {
      _subTotalCartMoney = _subTotalCartMoney +
          (element.priceCartProduct * element.quantityCartProduct.value);
      _nrProductInCart = _nrProductInCart + element.quantityCartProduct.value;
    }

    totalCartProductType.value = _nrProductTypeInCart;
    totalCartProduct.value = _nrProductInCart;
    subTotalCartMoney.value = _subTotalCartMoney;
    totalCartMoney.value = _subTotalCartMoney;
  }

  getCart() {
    return currentCartModel;
  }

  Future addToCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required int quantity,
      double? price,
      required List<CartProductVariants?> cartProductVariants,
      String? notes}) async {
    try {
      bool isOk = false;

      var response = await cartAPI.addToCart(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProduct: idProduct,
          quantity: quantity,
          price: price,
          cartProductVariants: cartProductVariants,
          notes: notes);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future findCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int cartStateEnum}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.findCart(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          cartStateEnum: cartStateEnum);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            CartModel cartModel = CartModel.fromJson(parseData['okResult']);
            setCart(cartModel);
            return cartModel;
          } else {
            setCart(CartModel.empty());
            return null;
          }
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future updateItemQuantity(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required int idCartProduct,
      required int quantityCartProduct}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.updateCartProduct(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCart: idCart,
          idCartProduct: idCartProduct,
          quantityCartProduct: quantityCartProduct);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          CartModel cartModel = CartModel.fromJson(parseData['okResult'] ?? '');
          setCart(cartModel);
          if (quantityCartProduct == 0) {
            notifyListeners();
          }
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future setCartCheckout(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String typePayment,
      required double totalPriceCart}) async {
    try {
      bool isOk = false;
      int savedIdCart = 0;
      var response = await cartAPI.setCartCheckout(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          totalPriceCart: totalPriceCart,
          typePayment: typePayment);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Autenticazione",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          CartModel cartModelDetail = CartModel.fromJson(parseData['okResult']);
          savedIdCart = cartModelDetail.idCart;
          // notifyListeners();
        }
      }
      return savedIdCart;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getInvoiceType(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution}) async {
    try {
      List<InvoiceTypeModel> invoiceTypeModel = List<InvoiceTypeModel>.empty();
      bool isOk = false;
      var response = await cartAPI.getInvoiceType(
          token: token, idUserAppInstitution: idUserAppInstitution);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            invoiceTypeModel = List.from(parseData['okResult'])
                .map((e) => InvoiceTypeModel.fromJson(e))
                .toList();
          }
        }
      }

      return invoiceTypeModel;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
      return List<InvoiceTypeModel>.empty();
    }
  }

  Future getInvoice(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String emailName}) async {
    try {
      var response = await cartAPI.getInvoice(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCart: idCart,
          emailName: emailName);

      if (response != null) {
        // var dir = await getTemporaryDirectory();
        // File file = File("${dir.path}/data.pdf");
        // await file.writeAsBytes(response, flush: true);
        return response;
        // return file.path;
      } else {
        return null;
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future cartToStakeholder(
      {required BuildContext context,
      required String? token,
      required int idCart,
      required int idUserAppInstitution,
      required int idStakeholder}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.cartToStakeholder(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          idStakeholder: idStakeholder);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }

  void setFirstRoute() {
    Navigator.pushNamedAndRemoveUntil(
        ContextKeeper.buildContext, AppRouter.cartRoute, (_) => true);
  }
}
