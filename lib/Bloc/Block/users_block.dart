import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/State/users_state.dart';
import 'package:npos/Bloc/Event/users_event.dart';
import 'package:npos/Model/user.dart';
import 'package:npos/Repository/user_repos.dart';

class AlbumsBloc extends Bloc<AlbumEvents,AlbumsState>
{

  final Albumsrepository albumsrepository;
  late List<Albums> listAlbums;
  AlbumsBloc({required this.albumsrepository}) : super(AlbumInitialState());

  @override
  Stream<AlbumsState> mapEventToState(AlbumEvents event) async* {

    switch(event)
    {
      case AlbumEvents.fetchAlbums:

        yield  AlbumLoadingState();

        try {
          listAlbums = await albumsrepository.getAlbumsList();

          yield AlbumLoadedState(albums: listAlbums);

        }on SocketException {
          yield AlbumListErrorstate(
            error: ('No Internet'),
          );
        } on HttpException {
          yield AlbumListErrorstate(
            error: ('No Service'),
          );
        } on FormatException {
          yield AlbumListErrorstate(
            error: ('No Format Exception'),
          );
        } catch (e) {
          print(e.toString());
          yield AlbumListErrorstate(
            error: ('Un Known Error ${e.toString()}'),
          );
        }
        break;
    }

  }

}