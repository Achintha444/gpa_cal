import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_event.dart';
import 'package:gpa_cal/ui/add_semester_page/add_semester_exports.dart';
import 'package:gpa_cal/util/db_util/regex_input_formatter.dart';

import '../../../db/model/user_details_model.dart';
import '../../../theme/project_theme.dart';
import '../../../util/db_util/gpa_conversion.dart';
import '../add_semester_bloc.dart';

class SubjectCard extends StatefulWidget {
  final int index;
  final Function onDelete;
  final UserDetailsModel userDetailsModel;

  const SubjectCard(
      {Key key,
      @required this.index,
      @required this.onDelete,
      @required this.userDetailsModel})
      : super(key: key);

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  /*  {
      'course': this.course,
      'result': this.result,
      'credit': this.result
    }*/

  String course = '';
  String resultValue;
  String credit;
  Map subject;
  @override
  void initState() {
    resultValue = _selectResultType()[1];
    credit = '2';
    subject = {
      'result': resultValue,
      'credit': credit,
    };

    BlocProvider.of<AddSemesterBloc>(context).add(
      AddSubjectsEvent(subject, widget.index, widget.userDetailsModel.gpaType),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final _addSemesterBloc = BlocProvider.of<AddSemesterBloc>(context);

    return Container(
      height: MediaQuery.of(context).size.height / 5.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ProjectColours.HOME_PAGE_EMPTY_CARD_COLOR,
        boxShadow: [
          BoxShadow(
            color: ProjectColours.HOME_PAGE_EMPTY_CARD_SHADOW_COLOR
                .withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocBuilder<AddSemesterBloc, AddSemesterState>(
        builder: (context, state) {
          return Row(
            children: [
              SizedBox(width: 24),

              // TextBoxes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    //Subject
                    TextFormField(
                      onChanged: (newValue) {
                        setState(() {
                          course = newValue;
                          subject['course'] = course;
                        });
                        _addSemesterBloc.add(
                          AddSubjectsEvent(subject, widget.index,
                              widget.userDetailsModel.gpaType),
                        );
                      },
                      keyboardType: TextInputType.name,
                      decoration:
                          (state.emptySubjects.indexOf(widget.index) == -1)
                              ? _inputDecortaiton('Course')
                              : _inputErrorDecortaiton('Course'),
                      style: _inputTextStyle(FontWeight.w500),
                    ),

                    SizedBox(height: 14),

                    // Result and Credit
                    Row(
                      children: [
                        // Result
                        Expanded(
                          child: InputDecorator(
                            decoration: _inputDecortaiton('Result'),
                            child: DropdownButton<String>(
                              style: _inputTextStyle(FontWeight.w700),
                              elevation: 4,
                              underline: SizedBox(height: 0),
                              isExpanded: true,
                              isDense: true,
                              iconEnabledColor: ProjectColours.PRIMARY_COLOR,
                              value: resultValue,
                              iconSize: 24,
                              onChanged: (String newValue) {
                                setState(() {
                                  resultValue = newValue;
                                  subject['result'] = resultValue;
                                });
                                _addSemesterBloc.add(
                                  AddSubjectsEvent(subject, widget.index,
                                      widget.userDetailsModel.gpaType),
                                );
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return _selectResultType()
                                    .map((value) => Text(
                                          value,
                                          style:
                                              _inputTextStyle(FontWeight.w500),
                                        ))
                                    .toList();
                              },
                              items: _selectResultType()
                                  .map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value+' : '+_selectResultMap()[value].toString(),
                                      style: _inputTextStyle(FontWeight.w700),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),

                        SizedBox(width: 8),

                        // Credit
                        Expanded(
                          child: TextFormField(
                            initialValue: credit,
                            toolbarOptions: ToolbarOptions(paste: false),
                            onChanged: (newValue) {
                              print(newValue);
                              setState(() {
                                credit = newValue;
                                subject['credit'] = credit;
                              });
                              _addSemesterBloc.add(
                                AddSubjectsEvent(subject, widget.index,
                                    widget.userDetailsModel.gpaType),
                              );
                            },
                            decoration:
                                (state.emptySubjects.indexOf(widget.index) ==
                                        -1)
                                    ? _inputDecortaiton('Credit')
                                    : _inputErrorDecortaiton('Credit'),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              Util.decimalFormatter,
                            ],
                            style: _inputTextStyle(FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),

              SizedBox(width: 24),

              // bin
              Container(
                width: 48,
                height: MediaQuery.of(context).size.height / 5.5,
                decoration: BoxDecoration(
                  color: ProjectColours.PRIMARY_COLOR,
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(color: ProjectColours.PRIMARY_COLOR, width: 5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: ProjectColours.BUTTON_BG_COLOR,
                  onPressed: () => widget.onDelete(widget.index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<String> _selectResultType() {
    if (widget.userDetailsModel.gpaType == 0) {
      return GpaConversion.resultList0;
    }
    return GpaConversion.resultList1;
  }

  Map _selectResultMap() {
    if (widget.userDetailsModel.gpaType == 0) {
      return GpaConversion.gpa0;
    }
    return GpaConversion.gpa1;
  }

  TextStyle _inputTextStyle(FontWeight fontWeight) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight,
      letterSpacing: 0.15,
      color: Colors.black,
      fontFamily: 'Montserrat',
    );
  }

  InputDecoration _inputDecortaiton(String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: const EdgeInsets.only(
        left: 16.0,
        right: 8,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: TextStyle(
        color: ProjectColours.PRIMARY_COLOR.withOpacity(0.75),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _inputErrorDecortaiton(String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: const EdgeInsets.only(
        left: 16.0,
        right: 8,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ProjectColours.ERROR_COLOR,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: TextStyle(
        color: ProjectColours.ERROR_COLOR.withOpacity(0.75),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontSize: 14,
      ),
    );
  }
}
