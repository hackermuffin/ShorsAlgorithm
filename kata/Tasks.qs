namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;


    operation IsEven(N : Int) : Bool {
        //TODO
        return false;
    }



    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    operation Test(qs : Qubit[]) : Unit {
        ApplyToEach(H,qs);
    }

    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit {
        //MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}