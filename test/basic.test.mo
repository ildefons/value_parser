import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import vparser "../src";

actor class({ledgerId: Principal}) = this {

    public func test() : async Nat { 
        Debug.print("Basic");
        let trx : vparser.Value = #Map([("f1",#Int(3)),
                                        ("f2",#Map([("g1", #Text("Hello")),
                                                    ("g2", #Nat(1)),
                                                    ("g3", #Int(3))]
                                                  )
                                        ),
                                        ("f3",#Array([#Int(1),#Int(2),#Int(3)]))
                                       ]);
        let aux =  vparser.gmap(#Ok(?trx), "f1");
        Debug.print(debug_show(aux));
        let aux2 =  vparser.gmap(#Ok(?trx), "f2") |> vparser.gmap(_, "g1");
        Debug.print(debug_show(aux2));
        let aux3 =  vparser.gmap(#Ok(?trx), "f2") |> vparser.gmap(_, "g2") |> vparser.gterminal(_, #Nat(1));
        Debug.print(debug_show(aux3));
        let aux4 =  vparser.gmap(#Ok(?trx), "f2") |> vparser.gmap(_, "g2") |> vparser.gterminal(_, #Nat(2));
        Debug.print(debug_show(aux4));
        let aux5 =  vparser.gmap(#Ok(?trx), "f3") |> vparser.gterminal(_, #Array([#Int(1),#Int(2),#Int(3)]));
        Debug.print(debug_show(aux5));
        let aux6 =  vparser.gmap(#Ok(?trx), "f2") |> vparser.gterminal(_, #Map([("g1", #Text("Hello")),
                                                                                ("g2", #Nat(1)),
                                                                                ("g3", #Int(3))]));
        Debug.print(debug_show(aux6));
        return 5;

    };

}