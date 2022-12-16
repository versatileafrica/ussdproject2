import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/AppBarreDesign.dart';

class RouteHelper {
  static const String initial = '/';
  static const String listArticle = '/articles-list-screen';
  static const String articles = '/articles-screen';
  static const String modifarticles = '/modif-articles-screen';
  static const String ventes = '/ventes-screen';
  static const String commandesection = '/commandesection';
  static const String stockart = '/stockarticles';
  static const String bilanscreen = '/bilanscreen';
  static const String bilandayscreen = '/bilandayscreen';
  static const String bilanperiodscreen = '/bilanperiodscreen';
  static const String approvisionnement = '/appro-screen';
  static const String historique = '/historique-screen';

  //static const String detcommandesection = '/detailscommandesection';
  //
  static String getInitial() => '$initial';

  ///static String getdetailscommandesection() => '$detcommandesection';
  //

  static List<GetPage> routes = [
    //home screen
    // GetPage(name: initial, page: () => appbarmode()),
    //article list
    // GetPage(
    //   name: listArticle,
    //   page: () {
    //     return const ArticlesListScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //articles
    // GetPage(
    //   name: articles,
    //   page: () {
    //     return const ArticlesScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //modif articles
    // // GetPage(
    // //   name: modifarticles,
    // //   page: () {
    // //     return const ModifArticlesScreen();
    // //   },
    // //   transition: Transition.fadeIn,
    // // ),
    // //ventes
    // GetPage(
    //   name: ventes,
    //   page: () {
    //     // return const VentesScreen();
    //     return const AppCommande();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //Commande en cours
    // GetPage(
    //   name: commandesection,
    //   page: () {
    //     return const CommandeListScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //details Commande en cours
    // // GetPage(
    // //   name: detcommandesection,
    // //   page: () {
    // //     return const DetailsCommandesection();
    // //   },
    // //   transition: Transition.fadeIn,
    // // ),
    // //dépenses
    // //stocks
    // GetPage(
    //   name: stockart,
    //   page: () {
    //     return const StockArticleList();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //Bilans
    // GetPage(
    //   name: bilanscreen,
    //   page: () {
    //     return const BilanScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //Bilans day
    // GetPage(
    //   name: bilandayscreen,
    //   page: () {
    //     return const BilanDayScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //Bilans periodique
    // GetPage(
    //   name: bilanperiodscreen,
    //   page: () {
    //     return const BilanPeriodScreen();
    //   },
    //   transition: Transition.fadeIn,
    // ),
    // //Approvisionnement
    // GetPage(
    //   name: approvisionnement,
    //   page: () {
    //     //return const ApproScreen();
    //     return const AppAppro();
    //   },
    //   transition: Transition.fadeIn,
    // ),

    // //historique
    // GetPage(
    //   name: historique,
    //   page: () {
    //     return const Historique();
    //   },
    //   transition: Transition.fadeIn,
    // ),

    //caisse
  ];
}
