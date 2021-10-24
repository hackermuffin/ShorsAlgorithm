namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
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

    operation FindOrderClassicalHelper(a : BigInt, N: BigInt) : Int {
        mutable power = 0;
        repeat {
            set power += 1;
        } until (a^power % N == 1L);
        return power;
    }
    operation FindOrderClassical(a : Int, N : Int) : Int{
        return FindOrderClassicalHelper(IntAsBigInt(a),IntAsBigInt(N));
    }


    operation GenerateRandomNumber(N : Int) : Int {
        use register = Qubit[BitSizeI(N-2)];
        mutable result = 0;
        repeat {
            ApplyToEachCA(H,register);
            set result = MeasureInteger(LittleEndian(register));
        } until ((result + 2) < N);
        return result+2;
    }

    operation GeneralCase(OrderFinder : ((Int, Int)=>Int), N : Int) : (Int, Int) {
        mutable result = 0;
        repeat {
            let a = GenerateRandomNumber(N);
            let gcd = GreatestCommonDivisorI(a,N);
            if (gcd > 1) {
                return (gcd, N/gcd);
            }
            let r = OrderFinder(a,N);
            if (IsEven_Reference(r)) {
                let x = (a^(r/2) - 1) % N;
                let gcdX = GreatestCommonDivisorI(x,N);
                if (gcdX > 1) {
                    set result = gcdX;
                }
            }
        } until (result != 0);
        return (result, N/result);
    }

    operation ShorsAlgorithm(OrderFinder : (Int, Int)=> Int, N : Int) : (Int, Int) {
        if IsEven_Reference(N) {
            return (2, N/2);
        }
        if IsPrime_Reference(N) {
            fail IntAsString(N) + " is prime, so doesn't have factors.";
        }
        return GeneralCase_Reference(OrderFinder, N);
    }

    operation ShorsAlgorithmClassical(N : Int) : (Int, Int) {
        return ShorsAlgorithm(FindOrderClassical, N);
    }

    // task 2

    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit is Adj+Ctl {
        MultiplyByModularInteger(ExpModI(a, power, N), N, LittleEndian(target));
    }

    operation PrepareEigenstate(eigenstate : Qubit[]) : Unit is Adj+Ctl {
        X(eigenstate[0]);
    }

    operation ApplyQuantumPhaseEstimation(oracle : DiscreteOracle, eigenstate : Qubit[], result : Qubit[]) : Int {
        let resultBELE = LittleEndianAsBigEndian(LittleEndian(result));
        QuantumPhaseEstimation(oracle,eigenstate,resultBELE);
        return MeasureInteger(LittleEndian(result));
    }

    operation PhaseResultToOrder(phaseResult : Int, bitsPrecision : Int, N : Int) : Int {
        let fractionResult = Fraction(phaseResult,2^bitsPrecision);
        let simplifiedFraction = ContinuedFractionConvergentI(fractionResult, N);
        let (numerator, period) = simplifiedFraction!;
        return AbsI(period);
    }

    operation FindOrderQuantum(a : Int, N : Int) : Int {
        mutable result = 1;
        let bitsize = BitSizeI(N);
        let bitsPrecision = 2 * bitsize + 1; // decide on precision?
        
        repeat {
            // setup register holding 'eigenstate' of |1>
            use eigenstate = Qubit[bitsize];
            PrepareEigenstate(eigenstate);
            
            // setup register to contain QFE result
            use phaseResult = Qubit[bitsPrecision];
            
            // measure the result from QPE
            let oracle = DiscreteOracle(OrderFindingOracle(a,N,_,_));
            //QuantumPhaseEstimation(oracle, eigenstate, LittleEndianAsBigEndian(phaseResultLE));
            let phaseResultI = ApplyQuantumPhaseEstimation(oracle, eigenstate, phaseResult);
            
            ResetAll(eigenstate);
            
            
            // calculate the period based of the phase result
            let period = PhaseResultToOrder(phaseResultI,bitsPrecision,N);
            
            // deal with a zero return value
            if (period == 0) { set result = 1; }
            // account for sub factors
            else { set result = (period * result) / GreatestCommonDivisorI(result, period); }
            
        }
        until (ExpModI(a,result,N) == 1);
        return result;
    }

    operation ShorsAlgorithmQuantum(N : Int) : (Int, Int) {
        return ShorsAlgorithm(FindOrderQuantum,N);
    }


}