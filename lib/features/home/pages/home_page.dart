import 'package:edit_skin_melon/features/home/bloc/melon_mods_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<MelonModsBloc>().add(MelonModsInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MelonModsBloc, MelonModsState>(
        builder: (context, state) {
          if (state is MelonModsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MelonModsComplete) {
            if (state is MelonModsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.failure.code.toString()),
                    Text(state.failure.message),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                  margin: EdgeInsets.only(bottom: 10),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
