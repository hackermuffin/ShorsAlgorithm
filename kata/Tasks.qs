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
        let sqrtN = Truncate(Sqrt(IntAsDouble(N)));
        for i in 5..6..sqrtN {
            if (N%i == 0) or (N%(i+2) == 0) {
                return false;
            }
        }
        return true;
    }

    operation GreatestCommonDivisor(a : Int, N : Int) : Int {
        let min = Min([a,N]);
        mutable gcd = 1;
        for i in 2..min {
            if (a%i == 0 and N%i == 0) {
                set gcd = i;
            }
        }
        return gcd;
    }

    operation FindOrderClassical(a : BigInt, N : BigInt) : Int {
        mutable power = 0;
        repeat {
            set power += 1;
        } until (a^power % N == 1L);
        return power;
    }

    operation Test(qs : Qubit[]) : Unit {
        ApplyToEach(H,qs);
    }

    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit {
        //MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

}