// ignore_for_file: file_names

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../../RespnseMsg/CustomResponse.dart';
import '../../../Services/Supabase/supabaseEnv.dart';

viewNearbyStationResponse(Request req, String address) async {
  try {
    final jwt = JWT.decode(req.headers["authorization"]!);
    final userAuth = jwt.payload["sub"];
    final supabase = SupabaseEnv().supabase;
    // final result = await supabase
    //     .from("consumers")
    //     .select("address")
    //     .eq("id_auth", userAuth);
    final resultStation = await supabase
        .from("stations")
        .select("location,rating")
        .contains("location", address);
    if (resultStation.toString().isEmpty) {
      return CustomResponse().errorResponse(msg: 'There is no Stations nearby');
    }
    return Response.ok(
      json.encode(resultStation),
      headers: {"content-type": "application/json"},
    );
  } catch (error) {
    return CustomResponse().errorResponse(msg: error.toString());
  }
}
