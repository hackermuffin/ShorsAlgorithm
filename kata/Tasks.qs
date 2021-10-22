namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation IsEven(N : Int) : Bool {
        return (N%2 == 0);
    }



    operation Test(qs : Qubit[]) : Unit {
        ApplyToEach(H,qs);
    }

    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit {
        //MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}