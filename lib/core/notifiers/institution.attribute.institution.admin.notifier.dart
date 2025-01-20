import 'dart:convert';
import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.alert.dialog.dart';
import 'package:np_casse/core/api/authentication.api.dart';
import 'package:np_casse/core/api/institution.attribute.api.dart';
import 'package:np_casse/core/api/user.api.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/cart.navigator.dart';
import 'package:np_casse/screens/loginScreen/login.view.dart';
import 'package:np_casse/screens/shopScreen/widget/shop.grant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstitutionAttributeInstitutionAdminNotifier with ChangeNotifier {
  final InstitutionAttributeAPI institutionAttributeAPI =
      InstitutionAttributeAPI();

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setUpdate(bool value) {
    _isUpdated = value;
    notifyListeners();
  }

  Future getInstitutionAttribute(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      bool? isDelayed}) async {
    try {
      if (isDelayed != null && isDelayed) {
        await Future.delayed(const Duration(seconds: 2));
      }
      var response = await institutionAttributeAPI.getInstitutionAttribute(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni ente",
                    message: errorDescription,
                    contentType: "failure"));
            return null;
          }
        } else {
          List<InstitutionAttributeModel> attribute =
              List.from(parseData['okResult'])
                  .map((e) => InstitutionAttributeModel.fromJson(e))
                  .toList();
          return attribute;
          // notifyListeners();
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future updateInstitutionPaymentMethodAttribute({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required int idPaymentTypeContanti,
    required int idPaymentTypeBancomat,
    required int idPaymentTypeCartaCredito,
    required int idPaymentTypeAssegni,
  }) async {
    try {
      var response =
          await institutionAttributeAPI.updateInstitutionPaymentMethodAttribute(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idInstitution: idInstitution,
              idPaymentTypeContanti: idPaymentTypeContanti,
              idPaymentTypeBancomat: idPaymentTypeBancomat,
              idPaymentTypeCartaCredito: idPaymentTypeCartaCredito,
              idPaymentTypeAssegni: idPaymentTypeAssegni);

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Impostazioni ente",
              message: errorDescription,
              contentType: "failure"));
          // _isLoading = false;
          // notifyListeners();
        }
      } else {
        // notifyListeners();
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));

        // _isLoading = false;
        // notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));
        // _isLoading = false;
        // notifyListeners();
      }
    }
  }

  Future updateInstitutionStripeAttribute({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String stripeApiKey,
  }) async {
    try {
      var response =
          await institutionAttributeAPI.updateInstitutionStripeAttribute(
        token: token,
        idUserAppInstitution: idUserAppInstitution,
        idInstitution: idInstitution,
        stripeApiKey: stripeApiKey,
      );

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Impostazioni ente",
              message: errorDescription,
              contentType: "failure"));
          // _isLoading = false;
          // notifyListeners();
        }
      } else {
        // notifyListeners();
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));

        // _isLoading = false;
        // notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));
        // _isLoading = false;
        // notifyListeners();
      }
    }
  }

  Future updateInstitutionSecurityAttribute({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String otpMode,
    required int tokenExpiration,
    required int maxInactivity,
  }) async {
    try {
      var response =
          await institutionAttributeAPI.updateInstitutionSecurityAttribute(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idInstitution: idInstitution,
              otpMode: otpMode,
              tokenExpiration: tokenExpiration,
              maxInactivity: maxInactivity);

      final Map<String, dynamic> parseData = await jsonDecode(response);
      bool isOk = parseData['isOk'];
      if (!isOk) {
        String errorDescription = parseData['errorDescription'];
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Impostazioni ente",
              message: errorDescription,
              contentType: "failure"));
          // _isLoading = false;
          // notifyListeners();
        }
      } else {
        // notifyListeners();
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));

        // _isLoading = false;
        // notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni ente",
            message: "Errore di connessione",
            contentType: "failure"));
        // _isLoading = false;
        // notifyListeners();
      }
    }
  }

  Future updateCasseModuleDataAttribute(
      {required BuildContext context,
      String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool institutionFiscalized,
      required bool posAuthorization}) async {
    try {
      var response =
          await institutionAttributeAPI.updateCasseModuleDataAttribute(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idInstitution: idInstitution,
              institutionFiscalized: institutionFiscalized,
              posAuthorization: posAuthorization);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Impostazioni modulo casse",
                    message: errorDescription,
                    contentType: "failure"));
            // _isLoading = false;
            // notifyListeners();
          }
        } else {
          // notifyListeners();
        }
        return isOk;
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni modulo casse",
            message: "Errore di connessione",
            contentType: "failure"));

        // _isLoading = false;
        // notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Impostazioni modulo casse",
            message: "Errore di connessione",
            contentType: "failure"));
        // _isLoading = false;
        // notifyListeners();
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}
