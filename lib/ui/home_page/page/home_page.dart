import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../db/model/user_details_model.dart';
import '../../../db/model/user_result.dart';
import '../../../theme/project_theme.dart';
import '../widgets/semester_card.dart';

class HomePage extends StatelessWidget {
  final UserResultModel userResultModel;
  final UserDetailsModel userDetailsModel;

  const HomePage(
      {Key key,
      @required this.userResultModel,
      @required this.userDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: BouncingScrollPhysics(),
          children: [
            /// CGPA CARD
            CgpaCard(
              userDetailsModel: userDetailsModel,
              userResultModel: userResultModel,
            ),

            /// Semester Count
            SizedBox(height: 16),
            Text(
              'Semesters - ' + userResultModel.semesters.length.toString(),
              style: TextStyle(
                color: ProjectColours.PRIMARY_COLOR,
                fontSize: 14,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            
            /// Semsters List
            SemesterCard(),
          ],
        ),

        /// Add semester FAB
        FAB(),
      ],
    );
  }
}

class CgpaCard extends StatelessWidget {
  const CgpaCard({
    Key key,
    @required this.userDetailsModel,
    @required this.userResultModel,
  }) : super(key: key);

  final UserDetailsModel userDetailsModel;
  final UserResultModel userResultModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (123 / 823),
      //width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: ProjectThemes.containerDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: 'Hero Tag 2',
            child: SvgPicture.asset(
              'graphics/person.svg',
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * (96 / 411),
              height: MediaQuery.of(context).size.height / 8.5,
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: SizedBox()),
                Text(
                  userDetailsModel.uni,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  textWidthBasis: TextWidthBasis.parent,
                  style: TextStyle(
                    color: ProjectColours.PRIMARY_COLOR,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                //ErrorAnimatedWidget(child: null, direction: null)
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'CGPA',
                      style: TextStyle(
                        color: ProjectColours.SET_NAME_COLOUR,
                        fontSize: 14,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      userResultModel.cgpa.toString(),
                      style: TextStyle(
                        color: ProjectColours.SET_NAME_COLOUR,
                        fontSize: 24,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        userDetailsModel.gpaType == 0 ? '/4.0' : '/4.2',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: ProjectColours.PRIMARY_COLOR,
                          fontSize: 24,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: ProjectColours.BUTTON_BG_COLOR,
          icon: Icon(
            Icons.add,
            color: ProjectColours.PRIMARY_COLOR,
            size: 24,
          ),
          label: Text(
            'Add Semester',
            style: TextStyle(
              color: ProjectColours.PRIMARY_COLOR,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
