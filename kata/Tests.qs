namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    // pulled from https://github.com/microsoft/QuantumKatas/blob/main/GroversAlgorithm/Tests.qs
    operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
        for n in 2 .. 10 {
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }

    @Test("QuantumSimulator")
    operation IsEven_Test () : Unit {
        for i in 1..10 {
            EqualityFactB (IsEven(i), IsEven_Reference(i), "IsEven failed on " + IntAsString(i));
        }
    }

    @Test("QuantumSimulator")
    operation IsPrime_Test() : Unit {
        for i in 1..100 {
            EqualityFactB(IsPrime(i), IsPrime_Reference(i), "IsPrime failed on " + IntAsString(i));
        }
    }

    @Test("QuantumSimulator")
    operation GreatestCommonDivisor_Test() : Unit {
        for a in 2..10 {
            for N in 2..10 {
                EqualityFactI(GreatestCommonDivisor(a,N), GreatestCommonDivisor_Reference(a,N),
                    "GreatestCommonDivisor failed for a=" + IntAsString(a) + " N=" + IntAsString(N));
            }
        }
    }

    @Test("QuantumSimulator")
    operation FindOrderClassical_Test() : Unit {
        for a in 2..5 {
            for N in 10..15 {
                if (GreatestCommonDivisor_Reference(a, N) == 1) {
                    let bigA = IntAsBigInt(a);
                    let bigN = IntAsBigInt(N);
                    EqualityFactI(FindOrderClassical(bigA,bigN), FindOrderClassical_Reference(bigA,bigN),
                        "FindOrderClassical failed on a=" + IntAsString(a) + " N=" + IntAsString(N));
                }
            }
        }
    }


    @Test("QuantumSimulator")
    operation Test_Test () : Unit {
        let refOp = ApplyToEachCA(H,_);
        let testOp = Test;
        AssertOperationsEqualReferenced(3,testOp,refOp);
    }
    
    @Test("QuantumSimulator")
    operation OrderFindingOracle_Test () : Unit {
        let (a, N, r) = (2, 15, 3);
        let testOp = OrderFindingOracle(a,N,r,_);
        let refOp = OrderFindingOracle_Reference(a,N,r,_);
        use register = Qubit[BitSizeI(N)];
        within { ApplyToEachCA(H,register); }
        apply {
            testOp(register);
            //Adjoint refOp(register);
        }
        AssertAllZero(register);        
    }


}