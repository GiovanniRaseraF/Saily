import 'package:flutter/material.dart';

late BuildContext globalContext;

void setGlobalContext(BuildContext context){
  globalContext = context;
}

double gCtxH(){
  return ctxH(globalContext);
}

double gCtxW(){
  return ctxW(globalContext);
}

double gCtxHHalf(){
  return ctxH(globalContext) * 0.45;
}

double gCtxWHalf(){
  return ctxW(globalContext) * 0.43;
}

double gCtxHTird(){
  return ctxH(globalContext) * 0.25;
}

double gCtxWTird(){
  return ctxW(globalContext) * 0.25;
}

double ctxH(BuildContext context){
  return MediaQuery.of(context).size.height;
}

double ctxW(BuildContext context){
  return MediaQuery.of(context).size.width;
}