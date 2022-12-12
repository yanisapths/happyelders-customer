import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olive/common/app_constant.dart';
import '../../../app_theme.dart';
import '../../../common/material/OLBottomAction.dart';
import '../../../entities/daycare_entity.dart';
import 'daycare_detail_tab.dart';

class DaycareDetailScreen extends StatelessWidget {
  const DaycareDetailScreen({Key? key, this.daycareData, this.callBack})
      : super(key: key);

  final Daycare? daycareData;
  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar.large(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    splashColor: AppTheme.nearlyWhite,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left,
                        size: BACK_ARROW_SIZE, color: AppTheme.white),
                  ),
                  snap: false,
                  floating: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.40,
                  flexibleSpace: Stack(
                    children: [
                      Positioned(
                          child: Opacity(
                            opacity: 0.9,
                            child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(daycareData!.imageUrl)),
                          ),
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0),
                      Positioned(
                        child: Stack(children: [
                          Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                height: 110,
                                width: 500,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppTheme.pureBlack.withOpacity(0.5),
                                      blurRadius: 80,
                                      spreadRadius: 50,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(PADDING_30),
                                  ),
                                ),
                              )),
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: PADDING_26,
                                    bottom: PADDING_10,
                                    left: PADDING_24,
                                    right: PADDING_24),
                                child: Text(daycareData!.daycareName,
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: GoogleFonts.notoSansThai(
                                        textStyle: TextStyle(
                                            fontSize: AppTheme.FONT_24,
                                            color: AppTheme.pureBlack,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5))),
                              ),
                            ],
                          )
                        ]),
                        bottom: -1,
                        left: 0,
                        right: 0,
                      ),
                    ],
                  ),
                  forceElevated: innerBoxIsScrolled,
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              // Builder required to obtain correct BuildContext.
              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 1000.0,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                            child: DaycareDetailTab(
                          daycareData: daycareData,
                        ));
                      },
                      childCount: 1,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            elevation: PADDING_10,
            color: AppTheme.nearlyWhite,
            child: Padding(
                padding: const EdgeInsets.all(PADDING_18),
                child: OverflowBar(
                  overflowAlignment: OverflowBarAlignment.center,
                  alignment: MainAxisAlignment.center,
                  children: [
                    ButtonAction(
                      daycareData: daycareData,
                    )
                  ],
                ))));
  }
}
