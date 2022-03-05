import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:youtube_search_app/data/model/detail/model_detail.dart';
import 'package:youtube_search_app/ui/detail/detail.dart';
import 'package:youtube_search_app/ui/search/widget/centred_message.dart';

class DetailPage extends StatefulWidget {
  final String videoId;

  const DetailPage({Key key, @required this.videoId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _detailBloc = kiwi.Container().resolve<DetailBloc>();

  @override
  void initState() {
    super.initState();
    _detailBloc.onShowDetail(id: widget.videoId);
  }

  @override
  void dispose() {
    super.dispose();
    _detailBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _detailBloc,
      child: Scaffold(
        body: BlocBuilder(
          bloc: _detailBloc,
          builder: _buildScaffoldContent,
        ),
      ),
    );
  }

  Widget _buildScaffoldContent(BuildContext context, DetailState state){
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 178,
          pinned: true,
          flexibleSpace: _buildSliverAppBarContent(state),
        ),
        _buildPageBody(state)
      ],
    );
  }

  FlexibleSpaceBar _buildSliverAppBarContent(DetailState state){
    if(state.isLoading){
      return FlexibleSpaceBar();
    }
    if(state.isSuccessful){
      return FlexibleSpaceBar(
        title: Text(
          state.videoItem.snippet.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              state.videoItem.snippet.thumbnails.high.url,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.15, 0.5],
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent
                  ],
                )
              ),
            )
          ],
        ),
      );
    }else{
      return FlexibleSpaceBar(
        background: CentredMessage(
          message: state.error,
          icon: Icons.error_outline,
        ),
      );
    }
  }
  Widget _buildPageBody(DetailState state){
    if(state.isLoading){
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if(state.isSuccessful){
      return _buildVideoDetailList(state.videoItem.snippet);
    }else{
      return SliverFillRemaining(
        child: CentredMessage(
          message: state.error,
          icon: Icons.error_outline,
        ),
      );
    }
  }

  Widget _buildVideoDetailList(VideoSnippet snippet){
    return SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            SizedBox(height: 5,),
            Text(
                snippet.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
                ),
            ),
            SizedBox(height: 5,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width * 2,
                child: Wrap(
                  spacing: 10,
                  children: _getTagsAsChipWidgets(snippet),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(
              'Description',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(height: 5,),
            Text(snippet.description)
          ]
        ),
      ),
    );
  }

  List<Widget> _getTagsAsChipWidgets(VideoSnippet snippet){
     return snippet.tags.map((tag){
       return Chip(
          label: Text(tag),
       );
     }).toList();
  }
}

