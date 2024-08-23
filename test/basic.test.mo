import Nat "mo:base/Nat";
import vparser "../src";

actor class({ledgerId: Principal}) = this {

    public func test() : async vparser.Value { 
        return #Nat(5);
    };

}