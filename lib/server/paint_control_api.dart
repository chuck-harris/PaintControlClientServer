

import 'dart:async';
import 'package:rpc/rpc.dart';

import '../model/brand.dart';
import '../model/color_family.dart';
import '../model/database_access.dart';

@ApiClass( version: 'v0.1' )
class PaintControlApi {

  final DatabaseAccess databaseAccess = new DatabaseAccess();

  @ApiMethod( method: 'GET', path: 'color-families' )
  Future<List<ColorFamily>> listColorFamilies() async {

    var families = await databaseAccess.getColorFamilyList();
    return families;
  }

  @ApiMethod( method: 'GET', path: 'color-family/{id}' )
  Future<ColorFamily> getColorFamily( String id ) async {

    print( 'id = [${id}]' );

    int numId = int.parse( id, onError: (source) => null );
    if( numId == null ) {
      throw new RpcError( 400, 'Invalid ID', 'ID must be numeric: ${id}' );
    }

    var family = await databaseAccess.getColorFamily( numId );
    if( family == null ) {
      throw new RpcError( 404, 'Unknown ID', 'ID not found: ${id}' );
    }
    return family;
  }

  @ApiMethod( method: 'POST', path: 'color-family' )
  Future<ColorFamily> createColorFamily( ColorFamily family ) async {

    var newFamily = await databaseAccess.createColorFamily( family );
    return newFamily;
  }

  @ApiMethod( method: 'DELETE', path: 'color-family/{id}' )
  Future<ColorFamily> deleteColorFamily( String id ) async {

    int numId = int.parse( id, onError: (source) => null );
    if( numId == null ) {
      throw new RpcError( 400, 'Invalid ID', 'ID must be numeric: ${id}' );
    }

    var family = await databaseAccess.deleteColorFamily( numId );
    if( family == null ) {
      throw new RpcError( 404, 'Unknown ID', 'ID not found: ${id}' );
    }
    return family;
  }

  @ApiMethod( method: 'GET', path: 'brands' )
  Future<List<Brand>> listBrands() async {

    var brands = await databaseAccess.getBrandList();
    return brands;
  }
}



