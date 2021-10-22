namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;

    operation IsEven_Reference(N : Int) : Bool {
        return (N%2 == 0);
    }

    operation OrderFindingOracle_Reference(a : Int, N : Int, power : Int, target : Qubit[]) : Unit is Adj {
        MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}