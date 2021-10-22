namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation IsEven(N : Int) : Bool {
        return (N%2 == 0);
    }

    operation IsPrime(N : Int) : Bool {
        if (N <= 3) {
            return (N > 1);
        }
        if (N%2 == 0) or (N%3 == 0) {
            return false;
        }
        let sqrtN = DoubleAsInt(Sqrt(IntAsDouble(N)));
        for i in 5..6..sqrtN {
            if (N%i == 0) or (N%(i+2) == 0) {
                return false;
            }
        }
        return true;
    }

    operation Test(qs : Qubit[]) : Unit {
        ApplyToEach(H,qs);
    }

    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit {
        //MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}