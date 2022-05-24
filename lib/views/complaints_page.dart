import 'package:axios_admin/cubit/Complaints/complaints_cubit.dart';
import 'package:axios_admin/models/complaints_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        body: BlocBuilder<ComplaintsCubit,ComplaintsState>(
          builder: (BuildContext context, state){
            if(state is ComplaintsLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is ComplaintsFailed){
              return Center(child: Text(state.msg));
            }else if(state is ComplaintsInitial){
              List<ComplaintsModel> data = state.data;
              return Container(
                padding: const EdgeInsets.all(20),
                child: data.isNotEmpty?ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index)=>const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(data[index].category),
                      subtitle: Text(data[index].desc,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    );
                  },
                ):const Center(
                  child: Text("No Complaints yet..!"),
                ),
              );
            }else{
              return Container();
            }
          },
        )
    );
  }
}
