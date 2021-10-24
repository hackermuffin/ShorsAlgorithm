namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Oracles;

    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    // pulled from https://github.com/microsoft/QuantumKatas/blob/main/GroversAlgorithm/Tests.qs
    // operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
    //     for n in 2 .. 10 {
    //         AssertOperationsEqualReferenced(n, testOp, refOp);
    //     }
    // }

    @Test("QuantumSimulator")
    operation IsEven_Test () : Unit {
        Message("Starting IsEven_Test...");
        for i in 1..10 {
            EqualityFactB (IsEven(i), IsEven_Reference(i), "IsEven failed on " + IntAsString(i));
        }
    }

    @Test("QuantumSimulator")
    operation IsPrime_Test() : Unit {
        Message("Starting IsPrime_Test...");
        for i in 1..100 {
            EqualityFactB(IsPrime(i), IsPrime_Reference(i), "IsPrime failed on " + IntAsString(i));
        }
    }

    @Test("QuantumSimulator")
    operation FindOrderClassical_Test() : Unit {
        Message("Starting FindOrderClassical_Test...");
        for a in 2..5 {
            for N in 10..15 {
                if (GreatestCommonDivisorI(a, N) == 1) {
                    EqualityFactI(FindOrderClassical(a,N), FindOrderClassical_Reference(a,N),
                        "FindOrderClassical failed on a=" + IntAsString(a) + " N=" + IntAsString(N));
                }
            }
        }
    }

    @Test("QuantumSimulator")
    operation GenerateRandomNumber_Test() : Unit {
        Message("Starting GenerateRandomNumber_Test...");
        for _ in 0..10 {
            let result = GenerateRandomNumber(10);
            let inRange = result > 1 and result < 10;
            EqualityFactB(inRange,true,
                "Random number generator returned " + IntAsString(result) + " with N=10");
        }
    }

    @Test("QuantumSimulator")
    operation GeneralCase_Test() : Unit {
        Message("Starting GeneralCase_Test...");
        let valuesToFactorise = [4,6,8,10,14,15];
        for i in 0..Length(valuesToFactorise)-1 {
            let (factorOne, factorTwo) = GeneralCase(FindOrderClassical,valuesToFactorise[i]);
            let (factorOneRef, factorTwoRef) = GeneralCase_Reference(FindOrderClassical_Reference,valuesToFactorise[i]);
            let isMatch = (factorOne == factorOneRef and factorTwo == factorTwoRef) or (factorOne == factorTwoRef and factorTwo == factorOneRef);
            EqualityFactB(isMatch, true, 
                "General case failed on factorising " + IntAsString(valuesToFactorise[i])); 
        }
    }

    @Test("QuantumSimulator")
    operation ShorsAlgorithmClassical_Test() : Unit {
        Message("Starting ShorsAlgorithmClassical_Test...");
        let valuesToFactorise = [4,6,8,10,14,15];
        for i in 0..Length(valuesToFactorise)-1 {
            let (factorOne, factorTwo) = ShorsAlgorithmClassical(valuesToFactorise[i]);
            let (factorOneRef, factorTwoRef) = ShorsAlgorithmClassical_Reference(valuesToFactorise[i]);
            let isMatch = (factorOne == factorOneRef and factorTwo == factorTwoRef) or (factorOne == factorTwoRef and factorTwo == factorOneRef);
            EqualityFactB(isMatch, true, 
                "Shor's Algorithm failed on factorising " + IntAsString(valuesToFactorise[i])); 
        }
    }

    @Test("QuantumSimulator")
    operation OrderFindingOracle_Test () : Unit {
        Message("Starting OrderFindingOracle_Test...");
        let (a, N, r) = (2, 15, 3);
        let testOp = OrderFindingOracle(a,N,r,_);
        let refOp = OrderFindingOracle_Reference(a,N,r,_);
        use register = Qubit[BitSizeI(N)];
        within { ApplyToEachCA(H,register); H(register[0]); }
        apply {
            testOp(register);
            Adjoint refOp(register);
        }
        AssertAllZero(register);      
    }

    @Test("QuantumSimulator")
    operation PrepareEigenstate_Test () : Unit {
        Message("Starting PrepareEigenstate_Test...");
        for i in 1..4 {
            use register = Qubit[i];
            PrepareEigenstate(register);
            Adjoint PrepareEigenstate(register);
            AssertAllZero(register);
        }
    }

    @Test("QuantumSimulator")
    operation ApplyQuantumPhaseEstimation_Test() : Unit {
        Message("Starting ApplyQuantumPhaseEstimation_Test...");
        let a = 2;
        let N = 15;
        let vaildResults = [1*128,2*128,3*128];
        use eigenstate = Qubit[BitSizeI(N)];
        use result = Qubit[BitSizeI(N)*2 + 1];
        mutable foundCorrectResult = false;
        mutable count = 0;
        repeat {
            PrepareEigenstate_Reference(eigenstate);
            let resultI = ApplyQuantumPhaseEstimation(DiscreteOracle(OrderFindingOracle(a,N,_,_)),
                eigenstate,result);
            for answer in vaildResults {
                if (answer == resultI) {
                    set foundCorrectResult = true;
                }
            }
            ResetAll(eigenstate + result);
            set count += 1;
        } until (count >= 10 or foundCorrectResult)
        fixup {
            Message("ApplyQuantumPhaseEstimation_Test did not find valid result on attempt " + IntAsString(count) + ", retrying...");
        }
        EqualityFactB(foundCorrectResult,true,
            "ApplyQuantumPhaseEstimation failed to produce a valid result after 10 tries.");
    }

    @Test("QuantumSimulator")
    operation PhaseResultToPeriod_Test() : Unit {
        Message("Starting PhaseResultToPeriod_Test...");
        let phaseResults = [1*128,2*128,3*128];
        for i in 0..Length(phaseResults)-1 {
            EqualityFactI(PhaseResultToPeriod(phaseResults[i],9,15),PhaseResultToPeriod_Reference(phaseResults[i],9,15),
                "Phase results failed converting "+IntAsString(phaseResults[i])+" with N=15, precision=9");
        }
    }

    @Test("QuantumSimulator")
    operation FindOrderQuantum_Test() : Unit {
        Message("Starting FindOrderQuantum_Test...");
        for a in 2..5 {
            for N in 15..15 {
                if GreatestCommonDivisorI(a,N) == 1 {
                    let resRef = FindOrderClassical_Reference(a,N);
                    let resTest = FindOrderQuantum(a,N);
                    EqualityFactI(resTest, resRef,
                        "FindOrderQuantum failed on a=" + IntAsString(a) + " N=" + IntAsString(N));
                }
            }
        }
    }

    @Test("QuantumSimulator")
    operation ShorsAlgorithmQuantum_Test() : Unit {
        Message("Starting ShorsAlgorithmQuantum_Test...");
        let valuesToFactorise = [4,6,8,10,14,15];
        for i in 0..Length(valuesToFactorise)-1 {
            let (factorOne, factorTwo) = ShorsAlgorithmQuantum(valuesToFactorise[i]);
            let (factorOneRef, factorTwoRef) = ShorsAlgorithmClassical_Reference(valuesToFactorise[i]);
            let isMatch = (factorOne == factorOneRef and factorTwo == factorTwoRef) or (factorOne == factorTwoRef and factorTwo == factorOneRef);
            EqualityFactB(isMatch, true, 
                "Shor's Algorithm failed on factorising " + IntAsString(valuesToFactorise[i])); 
        }
    }
    
}