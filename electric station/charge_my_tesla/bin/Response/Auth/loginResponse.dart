// ignore_for_file: file_names

import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../RespnseMsg/CustomResponse.dart';
import '../../Services/Supabase/supabaseEnv.dart';

loginResponse(Request req) async {
  try {
    final body = json.decode(await req.readAsString());
    if (body["email"] == null || body["password"] == null) {
      return Response.badRequest(body: "add email and password please");
    }
    final auth = SupabaseEnv().supabase.auth;
    final userLogin = await auth.signInWithPassword(
      email: body["email"],
      password: body["password"],
    );

    String UserType = "CONSUMER";
    final supabase = SupabaseEnv().supabase;

    final List result = await supabase
        .from("providers")
        .select("id")
        .eq("email", body['email']);

    if (result.isNotEmpty) {
      UserType = "PROVIDER";
    }

    // return Response.ok(userLogin.session?.accessToken.toString());
    return CustomResponse().successResponse(msg: "success", data: {
      "token": userLogin.session?.accessToken.toString(),
      'UserType': UserType
    });
  } catch (error) {
    print(error);
    return Response.badRequest();
  }
}
