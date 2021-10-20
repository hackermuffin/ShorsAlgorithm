namespace PeriodFinder {
    open Microsoft.Quantum.Intrinsic;

    // open Microsoft.Quantum.Arithmetic;
    // open Microsoft.Quantum.Math;
    // open Microsoft.Quantum.Standard;
    


    // open Microsoft.Quantum.Convert;

    open Microsoft.Quantum.Canon;


    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;

    operation FindPeriod(a : Int, N : Int) : Int {
        return EstimatePeriod(a,N);
    }

    operation MultiplyMod(a : Int, N : Int, r : Int, target : Qubit[]) : Unit is Adj + Ctl {
        MultiplyByModularInteger(ExpModI(a,r,N), N, LittleEndian(target));
    } 

    operation EstimatePeriod(a : Int, N : Int) : Int {
        mutable result = 1;
        let bitsize = BitSizeI(N);
        let bitsprecision = 2 * bitsize + 1;

        repeat {
            mutable var = 0;

            use eigenstateRegister = Qubit[bitsize];
            let eigenstateRegisterLE = LittleEndian(eigenstateRegister);
            ApplyXorInPlace(1, eigenstateRegisterLE);

            let oracle = DiscreteOracle(MultiplyMod(a, N, _, _));

            use register = Qubit[bitsprecision];
            let var2 = LittleEndian(register);

            QuantumPhaseEstimation(oracle, eigenstateRegisterLE!, LittleEndianAsBigEndian(var2));

            set var = MeasureInteger(var2);

            ResetAll(eigenstateRegister);

            Message(IntAsString(var));

            let (numerator, period) = (ContinuedFractionConvergentI(Fraction(var, 2 ^ bitsprecision), N))!;
            let (numeratorAbs, periodAbs) = (AbsI(numerator), AbsI(period));

            //Message($"Estimated divisor of period is {periodAbs}, " + $" we have projected on eigenstate marked by {numeratorAbs}.");

            set result = (periodAbs * result) / GreatestCommonDivisorI(result, periodAbs);

        }
        until (ExpModI(a,result,N) == 1);

        return result;
    }
}