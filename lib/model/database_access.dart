import 'dart:async';
import 'package:postgres/postgres.dart';
import 'brand.dart';
import 'color_family.dart';


class DatabaseAccess {

  final connection = new PostgreSQLConnection( "localhost", 5432, "paint_control", username: 'paint_control', password: 'sn0tGreen' );

  Future<List<ColorFamily>> getColorFamilyList() async {

    List<ColorFamily> families = [];

    if( connection.isClosed )
      await connection.open();

    List<List<dynamic>> results = await connection.query( 'SELECT id, name FROM Families' );
    for( final row in results ) {
      var familyId = row[0];
      var familyName = row[1];
      ColorFamily family = new ColorFamily();
      family.id = familyId;
      family.name = familyName;
      families.add( family );
    }

    return families;
  }

  Future<ColorFamily> getColorFamily( int id ) async {

    ColorFamily family;

    if( connection.isClosed )
      await connection.open();

    List<List<dynamic>> results = await connection.query( 'SELECT id, name FROM Families where id = @id', substitutionValues: { 'id': id } );
    for( final row in results ) {
      var familyId = row[0];
      var familyName = row[1];
      family = new ColorFamily();
      family.id = familyId;
      family.name = familyName;
    }

    return family;
  }

  Future<ColorFamily> createColorFamily( ColorFamily family ) async {

    if( connection.isClosed )
      await connection.open();

    List<List<dynamic>> results = await connection.query( 'INSERT into Families ( name ) values ( @name ) RETURNING id', substitutionValues: { 'name': family.name });
    for( final row in results ) {
      var id = row[0];
      family.id = id;
    }

    return family;
  }

  Future<ColorFamily> deleteColorFamily( int id ) async {

    ColorFamily family;

    if( connection.isClosed )
      await connection.open();

    List<List<dynamic>> results = await connection.query( 'SELECT id, name FROM Families where id = @id', substitutionValues: { 'id': id } );
    for( final row in results ) {
      var familyId = row[0];
      var familyName = row[1];
      family = new ColorFamily();
      family.id = familyId;
      family.name = familyName;
    }
    if( family.id != null ) {
      await connection.query( 'DELETE FROM Families WHERE id = @id', substitutionValues: { 'id': id });
    }

    return family;
  }

  Future<List<Brand>> getBrandList() async {

    List<Brand> brands = [];

    if( connection.isClosed )
      await connection.open();

    List<List<dynamic>> results = await connection.query( "SELECT id, name FROM Brands" );
    for (final row in results) {
      var brandId = row[0];
      var brandName = row[1];
      Brand brand = new Brand( brandId, brandName );
      brands.add( brand );
    }

    return brands;
  }

}