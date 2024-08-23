
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import {Order} from "mo:base/Order";

module {
  
  public type ValueMap = (Text, Value);
  
  public type Value = { 
    #Blob : Blob; 
    #Text : Text; 
    #Nat : Nat;
    #Int : Int;
    #Array : [Value]; 
    #Map : [ValueMap]; 
  };

  public type ParseReturn = {
    #Err;
    #Ok: ?Value;
  };
  
  func compareMapArrayValue(v1: [(Text,Value)], v2:[(Text,Value)]) {
    // check different size return #less or #greater
    // if both size 0 retun equal
    // if same size, 
    //    compare first elements
    //    if first elements equal check recursively rest of array
    //    else return the compareArrayValue results on the rest of the array
    //         let v1c = Array.slice<Value>(v1, 1, v1.size());
    //         let v2c = Array.slice<Value>(v2, 1, v2.size());
  };
  
  func compareArrayValue(v1: [Value], v2:[Value]) {
    // check different size return #less or #greater
    // if both size 0 retun equal
    // if same size, 
    //    compare first elements
    //    if first elements equal check recursively rest of array
    //    else return the compareArrayValue results on the rest of the array
    //         let v1c = Array.slice<Value>(v1, 1, v1.size());
    //         let v2c = Array.slice<Value>(v2, 1, v2.size());
  };

  func compareValue(v1: Value, v2: Value): Order.Order {
    switch(v1,v2) {
      case (#Blob(v11),#Blob(v22)) {
        Blob.compare(v11,v22);
      };
      case (#Text(v11),#Text(v22)) {
        if(v11==v22) #equal;
        else if(v11<v22) #less;
        else #greater
      };
      case (#Nat(v11),#Nat(v22)) {
        if(v11==v22) #equal;
        else if(v11<v22) #less;
        else #greater
      };
      case (#Int(v11),#Int(v22)) { 
        if(v11==v22) #equal;
        else if(v11<v22) #less;
        else #greater
      };
      case (#Array(v11),#Array(v22)) {
        compareArrayValue(v11, v22);
      };
      case (#Map(v11),#Map(v22)) {
        compareMapArrayValue(v11, v22);
      };
      case (_) {
        #less
      };   
    };
};

  public func garray(values: Value, val: Value) : ParseReturn {

    switch(values) {
      case(#Array(myarray)) {
        let aux : ?Value = Array.find<Value>(myarray, func((d : Value)) = d == val);
        switch (aux) {
          case (?Value) return #Ok(?aux);
          case (_) return #Err;
        };
      };
      case(_) return #Err;
    };

  };    

  public func gmap(values: Value, key:Text) : ParseReturn {

    switch(values) {
      case(#Map(vmap)) {
        let aux : ?ValueMap = Array.find<ValueMap>(vmap, func((k : Text, d : Value)) = k == key);
        switch (aux) {
          case (?(a,b)) return #Ok(?b);
          case (_) return #Err;
        };
      };
      case(_) return #Err;
    };

  };  

};
