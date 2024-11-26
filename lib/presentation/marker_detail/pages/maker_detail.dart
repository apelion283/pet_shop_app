import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/cubit/marker_detail_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/cubit/marker_detail_state.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/widgets/marker_info_header.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/clip_path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class MarkerDetailPage extends StatefulWidget {
  const MarkerDetailPage({super.key});

  @override
  State<MarkerDetailPage> createState() => _MarkerDetailPageState();
}

class _MarkerDetailPageState extends State<MarkerDetailPage> {
  bool _isShimmer = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final arg =
        ModalRoute.of(context)!.settings.arguments as MarkerDetailPageArguments;

    return BlocProvider(
        create: (context) =>
            MarkerDetailCubit()..getMarkerDetailById(arg.markerId),
        child: BlocConsumer<MarkerDetailCubit, MarkerDetailState>(
          builder: (context, state) => RefreshIndicator(
              color: AppColor.green,
              onRefresh: () async {
                context
                    .read<MarkerDetailCubit>()
                    .getMarkerDetailById(arg.markerId);
              },
              child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColor.green,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: (Navigator.of(context).pop),
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppColor.white,
                              )),
                          _isShimmer
                              ? Shimmer.fromColors(
                                  baseColor: AppColor.green.withOpacity(0.4),
                                  highlightColor: AppColor.gray,
                                  child: SizedBox(
                                    width: 50,
                                    height: 25,
                                  ))
                              : Text(
                                  state.marker?.name ?? context.tr('loading'),
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                          SizedBox()
                        ]),
                  ),
                  body: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: size.height * 0.3,
                        flexibleSpace: FlexibleSpaceBar(
                          background: ClipPath(
                            clipper: ClipPathOnBoard(),
                            child: Hero(
                              tag: _isShimmer
                                  ? "loading".tr()
                                  : state.marker!.id,
                              child: _isShimmer
                                  ? Shimmer.fromColors(
                                      baseColor:
                                          AppColor.green.withOpacity(0.4),
                                      highlightColor: AppColor.gray,
                                      child: Image.network(
                                        AppConfig
                                            .placeHolderMerchandiseImageUrl,
                                        height: size.height * 0.3,
                                        width: size.width,
                                        fit: BoxFit.contain,
                                      ))
                                  : Image.network(
                                      state.marker!.imageUrl,
                                      height: size.height * 0.3,
                                      width: size.width,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          _isShimmer
                                              ? Shimmer.fromColors(
                                                  baseColor: AppColor.green
                                                      .withOpacity(0.4),
                                                  highlightColor: AppColor.gray,
                                                  child: Container(
                                                      color: AppColor.gray,
                                                      child: Text(
                                                        "loading".tr(),
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )))
                                              : Text(
                                                  state.marker!.name,
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              _isShimmer
                                                  ? Shimmer.fromColors(
                                                      baseColor: AppColor.green
                                                          .withOpacity(0.4),
                                                      highlightColor:
                                                          AppColor.gray,
                                                      child: Container(
                                                        color: AppColor.gray,
                                                        child: Text(
                                                          'work_time',
                                                          style: TextStyle(
                                                            color:
                                                                AppColor.blue,
                                                            fontSize: 15,
                                                          ),
                                                        ).tr(args: [
                                                          "loading",
                                                          "loading"
                                                        ]),
                                                      ))
                                                  : Text(
                                                      'work_time',
                                                      style: TextStyle(
                                                          color: AppColor.blue,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ).tr(args: [
                                                      (getHourAndMinuteFromDateTime(
                                                          state.marker!
                                                              .openTime)),
                                                      (getHourAndMinuteFromDateTime(
                                                          state.marker!
                                                              .closeTime))
                                                    ]),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                'loading',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 20),
                                              ).tr()))
                                      : Text(
                                          'marker_information',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ).tr(),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                'loading',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 18),
                                              ).tr()))
                                      : MarkerInfoHeader(
                                          sectionName: "address".tr(),
                                          headerIcon: Icons.location_on),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                "loading".tr(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              )))
                                      : Text(
                                          state.marker!.address,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                "loading".tr(),
                                                style: TextStyle(fontSize: 18),
                                              )))
                                      : MarkerInfoHeader(
                                          sectionName:
                                              "phone_number".tr(args: [""]),
                                          headerIcon: Icons.phone),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                "loading".tr(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              )))
                                      : Text(
                                          state.marker!.phoneNumber,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                "loading".tr(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15),
                                              )))
                                      : MarkerInfoHeader(
                                          sectionName: "description".tr(),
                                          headerIcon: Icons.description),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _isShimmer
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              AppColor.green.withOpacity(0.4),
                                          highlightColor: AppColor.gray,
                                          child: Container(
                                              color: AppColor.gray,
                                              child: Text(
                                                "loading".tr(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              )))
                                      : Text(
                                          state.marker!.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                  bottomNavigationBar: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: _isShimmer
                                      ? () {}
                                      : () {
                                          Share.share("let_check_this_store".tr(
                                              args: [
                                                "${AppConfig.customUri}${RouteName.markerDetail}?id=${state.marker!.id}"
                                              ]));
                                        },
                                  style: ElevatedButton.styleFrom(
                                      iconColor: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: AppColor.green),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 1),
                                      Text(
                                        'share',
                                        style: TextStyle(color: AppColor.white),
                                      ).tr(),
                                      Icon(
                                        Icons.share_outlined,
                                        color: AppColor.white,
                                      )
                                    ],
                                  ))),
                        ],
                      )))),
          listener: (context, state) {
            if (state.marker != null) {
              setState(() {
                _isShimmer = false;
              });
            }
          },
        ));
  }

  String getHourAndMinuteFromDateTime(DateTime time) {
    return "${time.hour}".padLeft(2, '0') + ":${time.minute}".padLeft(2, '0');
  }
}
