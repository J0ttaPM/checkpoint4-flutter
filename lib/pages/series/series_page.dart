import 'package:flutter/material.dart';
import 'package:movie_app/models/series_model.dart';
import 'package:movie_app/pages/series/widgets/series_widget.dart';
import 'package:movie_app/services/api_services.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  ApiServices seriesApi = ApiServices();
  late Future<SeriesModel> popularSeries;

  @override
  void initState() {
    popularSeries = seriesApi.getPopularSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Series'),
      ),
      body: FutureBuilder(
          future: popularSeries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              final seriesList = snapshot.data?.results;
              return ListView.builder(
                itemCount: seriesList!.length,
                itemBuilder: (context, index) {
                  return SeriesWidget(
                    series: seriesList[index],
                  );
                },
              );
            }

            return const Center(
              child: Text('No data found'),
            );
          }),
    );
  }
}
