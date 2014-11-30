#include <Rcpp.h>
 
using namespace Rcpp;

// [[Rcpp::export]]
CharacterVector fillTableCpp(CharacterVector a){
  int lengthArray=a.size();
  for(int i=1;i<lengthArray;i++){
    if(a[i]==""){
      a[i]=a[i-1];
    }else{
      a[i]=a[i];
    }
  }
  return a;
}