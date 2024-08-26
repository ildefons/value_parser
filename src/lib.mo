
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Order "mo:base/Order";

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
  
  //TBD
  func compareMapArrayValue(v1: [(Text,Value)], v2:[(Text,Value)]) : Bool {
    if (v1.size() != v2.size()) {return false;};
    if (v1.size() == 0) {return true;};
    let a: Bool = v1[0].0 == v2[0].0;
    let b: Bool = compareValue(?v1[0].1, ?v2[0].1);
    if (a==false or b==false) return false;
    compareMapArrayValue(Array.take(v1, -(v1.size()-1)), Array.take(v2, -(v2.size()-1)));    
  };
  
  func compareArrayValue(v1: [Value], v2:[Value]) : Bool {
    // check different size return #less or #greater
    if (v1.size() != v2.size()) return false;
    if (v1.size() == 0) return true;
    if (compareValue(?v1[0], ?v2[0]) == false) return false;
    compareArrayValue(Array.take(v1, -(v1.size()-1)), Array.take(v2, -(v2.size()-1)));
  };

  func compareValue(v1: ?Value, v2: ?Value): Bool {
    switch(v1,v2) {
      case (?#Blob(v11),?#Blob(v22)) {
        Blob.equal(v11,v22);
      };
      case (?#Text(v11),?#Text(v22)) {
        if (v11 == v22) {true;}
        else {false;}
      };
      case (?#Nat(v11),?#Nat(v22)) {
        if (v11 == v22) {true;}
        else {false;}
      };
      case (?#Int(v11),?#Int(v22)) { 
        if (v11 == v22) {true;}
        else {false;}
      };
      case (?#Array(v11),?#Array(v22)) {
        compareArrayValue(v11, v22);
      };
      case (?#Map(v11),?#Map(v22)) {
        compareMapArrayValue(v11, v22);
      };
      case (_) {
        false;
      };   
    };
  };

  public func garray(pr_in: ParseReturn, val: Value) : ParseReturn {

    switch (pr_in) {
      case (#Ok(values)) {
        switch(values) {
          case(?#Array(myarray)) {
            let aux : ?Value = Array.find<Value>(myarray, func((d : Value)) = compareValue(?d,?val));
            switch (aux) {
              case (?Value) return #Ok(aux);
              case (null) return #Err;
            };
          };
          case(_) return #Err;
        };
      };
      case (#Err) return #Err;
    };  
  };    

  public func gmap(pr_in: ParseReturn, key:Text) : ParseReturn {
    switch (pr_in) {
      case (#Ok(values)) {
        switch(values) {
          case(?#Map(vmap)) {
            let aux : ?ValueMap = Array.find<ValueMap>(vmap, func((k : Text, d : Value)) = k == key);
            switch (aux) {
              case (?(_,b)) return #Ok(?b);
              case (_) return #Err;
            };
          };
          case(_) return #Err;
        };
      };
      case (#Err) return #Err;
    };  
  };

  //   #Blob : Blob; 
  //   #Text : Text; 
  //   #Nat : Nat;
  //   #Int : Int;

  public func gterminal(pr_in: ParseReturn, key : Value) : ParseReturn {
    switch (pr_in) {
      case (#Ok(value)) {
        if (compareValue(value, ?key)) return pr_in;
        return #Err
      };
      case (#Err) return #Err;
    };
  };

  // I want to do something like 
  //      gmap(ge, "tx") |> gmap(_, "account") |> garr(_, 0) |> gblob(_)
  //      then, how to I manage  ---> check for #Err and propagate it
  //          , do we need N methods? Yes

};
