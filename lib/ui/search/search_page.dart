import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:youtube_search_app/data/model/search/model_search.dart';
import 'package:youtube_search_app/ui/detail/detail_page.dart';
import 'package:youtube_search_app/ui/search/search.dart';
import 'package:youtube_search_app/ui/search/widget/centred_message.dart';
import 'package:youtube_search_app/ui/search/widget/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchBloc = kiwi.Container().resolve<SearchBloc>();
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _searchBloc,
      child: _buildScaffold(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchBloc.dispose();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(),
      ),
      body: BlocBuilder(
        bloc: _searchBloc,
        builder: (context, SearchState state) {
          if (state.isInitial) {
            return CentredMessage(
              message: 'Start searching!',
              icon: Icons.ondemand_video,
            );
          } else if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.isSuccessful) {
            return _buildResultList(state);
          } else {
            return CentredMessage(
              message: state.error,
              icon: Icons.error_outline,
            );
          }
        },
      ),
    );
  }

  Widget _buildResultList(SearchState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView.builder(
        itemCount: _calculatedListItemCount(state),
        controller: _scrollController,
        itemBuilder: (context, index) {
          return index >= state.searchResults.length
              ? _buildLoaderListItem()
              : _buildVideoListItem(state.searchResults[index]);
        },
      ),
    );
  }

  int _calculatedListItemCount(SearchState state) {
    if (state.hasReachedEndOfResults) {
      return state.searchResults.length;
    } else {
      return state.searchResults.length + 1;
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      _searchBloc.fetchNextResultPage();
    }
    return false;
  }

  Widget _buildLoaderListItem() {
    return Center(child: CircularProgressIndicator());
  }
  
  Widget _buildVideoListItem(SearchItem searchItem){
    return GestureDetector(
      child: _buildVideoListItemCard(searchItem.snippet),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailPage(videoId: searchItem.id.videoId,);
        },));
      },
    );
  }

  Widget _buildVideoListItemCard(SearchSnippet snippet) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                    snippet.thumbnails.high.url,
                    fit: BoxFit.cover,
                )
            ),
            SizedBox(height: 5,),
            Text(
              snippet.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),
            SizedBox(height: 5,),
            Text(
              snippet.description,
            )
          ],
        ),
      ),
    );
  }
}
