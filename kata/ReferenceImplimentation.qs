namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;


    open Microsoft.Quantum.Intrinsic;

    operation IsEven_Reference(N : Int) : Bool {
        return (N%2 == 0);
    }

    // based on code from https://en.wikipedia.org/wiki/Primality_test#Python
    operation IsPrime_Reference(N : Int) : Bool {
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

    operation FindOrderClassical_Test(a : Int, N : Int) : Int {
        mutable power = 0;
        repeat {
            set power += 1;
        } until (a^power % N == 1);
        return power;
    }

    operation OrderFindingOracle_Reference(a : Int, N : Int, power : Int, target : Qubit[]) : Unit is Adj {
        MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}