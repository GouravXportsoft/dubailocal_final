import 'dart:developer';

import 'package:dubai_local/models/SubCategoryBusinessResponseModel.dart';
import 'package:dubai_local/services/networking_services/api_call.dart';
import 'package:dubai_local/services/networking_services/endpoints.dart';
import 'package:dubai_local/utils/header_widgets.dart';
import 'package:dubai_local/utils/routes/app_routes.dart';
import 'package:dubai_local/utils/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Constants.dart';
import '../utils/localisations/app_colors.dart';
import '../utils/localisations/images_paths.dart';

class DetailUi extends StatefulWidget {
  final Function(int index)? changeIndex;
  final Function(Map args)? setArgs;
  final Function() onBack;
  final Map args;

  const DetailUi(
      {Key? key,
      required this.changeIndex,
      required this.setArgs,
      required this.onBack,
      required this.args})
      : super(key: key);

  @override
  State<DetailUi> createState() => _DetailUiState();
}

class _DetailUiState extends State<DetailUi> {
  List<SubcatBusinessData> detailList = [];

  void getData(String slug) {
    CallAPI().getSubCategoriesBusiness(slug: slug).then((value) {
      if (value.subcatBusinessData!.isNotEmpty) {
        setState(() {
          detailList = value.subcatBusinessData!;
        });
      }
    }).onError((error, stackTrace) {
      print("$error $stackTrace");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final Map args =
      //     (ModalRoute.of(context)!.settings.arguments ?? {}) as Map;
      getData(widget?.args?["slug"] ?? "");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Map args = (ModalRoute.of(context)!.settings.arguments ?? {}) as Map;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Future<bool> _onWillPop() async {
      // Navigator.pop(context);
      widget.onBack();
      return false;
    }

    void openBusinessDetails(BuildContext context, String businessSlug) {
      // Navigator.pushNamed(context, AppRoutes.mainBusiness,
      //     arguments: {"slug": businessSlug});
      widget.setArgs!({"slug": businessSlug});
      widget.changeIndex!(8);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Column(
        children: [
          Column(
            children: [
              HeaderWidget(
                isBackEnabled: true,
                changeIndex: widget.changeIndex,
                onBack: widget.onBack,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Text(
                      widget.args["catName"] ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "-" + widget.args["subCat"] ?? "" + "-",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                detailList.isEmpty
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(Constants.themeColorRed),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        const SearchWidget(isLight: true),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: detailList.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return GestureDetector(
                                onTap: () {
                                  openBusinessDetails(
                                      context, detailList[index].slug!);
                                },
                                child: items(searchItems: detailList[index]),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget items({required SubcatBusinessData searchItems}) {
    const double cardHeight = 96;
    const double imageRatio = 0.8; // 0 - min, 1 - max
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 8,
        shadowColor: Colors.black,
        color: const Color(0xffF7F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: cardHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: cardHeight * imageRatio,
                      width: cardHeight * imageRatio,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "${Endpoints.BASE_URL}assets/logo/${searchItems.banner!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  searchItems.name!,
                                  style: const TextStyle(
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: [
                                    VxRating(
                                      onRatingUpdate: (v) {},
                                      size: 10,
                                      normalColor: AppColors.grey,
                                      selectionColor: AppColors.yellow,
                                      maxRating: 5,
                                      count: 5,
                                      value: searchItems.avgRating != null
                                          ? double.parse(double.parse(
                                                  searchItems.avgRating!)
                                              .toStringAsFixed(2))
                                          : 0,
                                      isSelectable: false,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff87B43D),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          "${double.tryParse(searchItems.avgRating!) ?? 0.toStringAsFixed(1)}",
                                          style: const TextStyle(
                                              fontSize: 6,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Image.asset(
                                  ImagesPaths.ic_location,
                                  color: const Color(0xff818181),
                                  width: 12,
                                  height: 12,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    searchItems.address!,
                                    style: const TextStyle(
                                      color: Color(0xff818181),
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                ImagesPaths.ic_phone,
                                color: const Color(0xff818181),
                                width: 12,
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  searchItems.phone!,
                                  style: const TextStyle(
                                    color: Color(0xff818181),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
