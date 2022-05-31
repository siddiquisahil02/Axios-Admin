import 'package:axios_admin/constants.dart';
import 'package:axios_admin/cubit/Complaints/complaints_cubit.dart';
import 'package:axios_admin/models/complaints_model.dart';
import 'package:axios_admin/utils/ui_constants.dart';
import 'package:axios_admin/views/photo_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  late final ComplaintsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ComplaintsCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Complaints'),
        ),
        body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          builder: (BuildContext context, state) {
            if (state is ComplaintsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComplaintsFailed) {
              return Center(child: Text(state.msg));
            } else if (state is ComplaintsInitial) {
              List<ComplaintsModel> data = state.data;
              return Container(
                padding: const EdgeInsets.all(20),
                child: data.isNotEmpty
                    ? ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (BuildContext context, int index) {
                          ComplaintsModel model = data[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: ListTile(
                              title: Text(model.category),
                              subtitle: Text(
                                data[index].desc,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              trailing: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: appRed),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 5),
                                  child: Text(
                                    model.status,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>  StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState){
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text(model.category),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7),
                                                      border: Border.all(width: 1),
                                                      color: Colors.grey.shade300
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 7, vertical: 5),
                                                  child: Text(DateFormat.yMMMd()
                                                      .add_jms()
                                                      .format(model.createdAt
                                                      .toDate())
                                                  )
                                              ),
                                              const SizedBox(height: 15),
                                              Text(model.residence,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text("\" ${model.desc} \""),
                                              const SizedBox(height: 15),
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 10,
                                                children: model.images
                                                    .map((String url) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(7),
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_)=>PhotoViewPage(urls: model.images)
                                                            )
                                                        );
                                                      },
                                                      child: Image.network(
                                                        url,
                                                        width: 100,
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                        loadingBuilder: (BuildContext
                                                        context,
                                                            Widget child,
                                                            ImageChunkEvent?
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) return child;
                                                          return Container(
                                                            height: 120,
                                                            width: 100,
                                                            alignment:
                                                            Alignment.center,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                border: Border.all()
                                                            ),
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 7, vertical: 5),
                                                            child:
                                                            CircularProgressIndicator(
                                                              value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                                  null
                                                                  ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              const SizedBox(height: 15),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(7),
                                                    border: Border.all(width: 1),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text("Status:",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        value: model.status,
                                                        hint: const Text("Change Status"),
                                                        items: status.map((e) =>
                                                            DropdownMenuItem(
                                                              child: Text(e),
                                                              value: e,
                                                            )
                                                        ).toList(),
                                                        onChanged: (String? val)async{
                                                          if(val!=null){
                                                            final String resId = box.read('resId');
                                                            model.status = val;
                                                            setState((){});
                                                            await firebase
                                                                .collection('operationalAt')
                                                                .doc(resId)
                                                                .collection('complaints')
                                                                .doc(model.id).update({
                                                              'status':val
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                ).whenComplete(() => cubit.emit(ComplaintsInitial(data: data)));
                              },
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text("No Complaints yet..!"),
                      ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
