namespace Quantum.Katas.ShorsAlgorithm {

    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // Shor's Algorithm is an quantum kata designed to teach the basics of
    // Shor's Algoirithm, which efficiently factorises large numbers on a 
    // quantum computer.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    //////////////////////////////////////////////////////////////////
    // Part I. A Classical Implementation
    //////////////////////////////////////////////////////////////////

    // Task 1.1. IsEven
    // This one use used to check if we can return the very fast calculation of $(2, N/2)$ as the factorisation.
    // Input:
    //     Any positive integer $N$
    // Goal:
    //     Return true if the number is even
    operation IsEven(N : Int) : Bool {
        // ...
        return false;
    }

    // Task 1.2. IsPrime
    // Used to check we can actually factor the number we are given. This is useful to prevent infinite loops 
    // and errors later on in the code.
    // This could be done by finding the factors, but that defeats the purpose of Shor's Algorithm. Faster methods 
    // (i.e. polynomial with respect to the number of bits of $N$) can be found 
    // [here](https://en.wikipedia.org/wiki/Primality_test#Example_code).
    // Input:
    //     Any positive integer $N$
    // Goal:
    //     Return true if $N$ is prime
    operation IsPrime(N : Int) : Bool {
        // ...
        return false;
    }

    // Task 1.3. Classical Order Finding
    // Shor's Algorithm uses a method called order finding for factorising. The order of two numbers $a, N$ is the 
    // value of $r > 0$ such that $a^r\mod N \equiv 1$. Consider the example of $a=2$, $N=15$.
    // | r | $$a^r$$ | $$a^r \mod N$$ |
    // | - | ------- | -------------- |
    // | 0 | 1       | 1              |
    // | 1 | 2       | 2              |
    // | 2 | 4       | 4              |
    // | 3 | 8       | 8              |
    // | 4 | 16      | 1              |
    // | 5 | 32      | 2              |
    // | ... | ...   | ...            |
    operation FindOrderClassical(a : Int, N : Int) : Int{
        // ...
        return 0;
    }

    // Task 1.4. Generate random number
    // Shor's Algorithm requires randomly selecting a value for $a$ to use in the order finding algorithm. This value 
    // should be $1 < a < N$. You could impliment this yourself by measuring qubits, or by using the libraries.
    // Integer:
    //     A positive integer $N$
    // Goal:
    //     A randomly generated number $a$ such that $1 < a < N$.
    operation GenerateRandomNumber(N : Int) : Int {
        // ...
        return 0;
    }

    // Task 1.5. General Case
    // Once we've check all the special cases, we need to implement the general algorithm to find factors off the order of two numbers.
    // With two numbers $a$ and $N$ with order $r$, there is a high chance that the greatest common divisor $\gcd(a^\frac{r}{2} \pm 1, N)$ 
    // is a factor of $N$.
    // So, the general case algorithm needs to:
    // 1. Pick a random number $1 < a < N$
    // 2. If $\gcd(a,N) > 1$ , give $\gcd(a,N)$ and $N/\gcd(a,N)$ as the factorisation
    // 3. Find the order of $a$ and $N$.
    // 4. If the order is odd start over, otherwise calculate $x = (a^\frac{r}{2} - 1)\mod N$
    // 5. If $\gcd(x,N) > 1$, give $\gcd(x,N)$ and $N/gcd(x,N)$ as the factorisation, otherwise start over 
    // Input:
    //     1. An order finding operation
    //     2. An integer $N$ to factor
    // Goal:
    //     A tuple of integers representing the factors of $N$
    operation GeneralCase(OrderFinder : ((Int, Int)=>Int), N : Int) : (Int, Int) {
        // ...
        return (0,0);
    }

    // Task 1.6. Full Shor's Implementation
    // Finally, we just need to put together all the piceces for the full factorisation algorithm. Remember to check if $N$ is even, 
    // and if $N$ is prime, throw an error. Otherwise, just apply the general factorising algorithm.
    // This one doesn't have a test, as it'll be tested after implimenting a specific classical/quantum version of the algorithm.
    // Input:
    //    1. An order finding operation
    //    2. An integer $N$ to factor
    // Goal:
    //    A tuple of integers representing the integer factors of $N$
    operation ShorsAlgorithm(OrderFinder : (Int, Int)=> Int, N : Int) : (Int, Int) {
        // ...
        return (0,0);
    }


    // Task 1.7. Classical Shor's Implimentation
    // Finally, we can put it all together to create a function that takes and integer and classically factors it using Shor's Algorithm. 
    // Once the code is written, feel free to test it on some values using the simulatation below.

    // Input: 
    //     An integer $N$ to factor
    // Goal:
    //     The prime factors of $N$
    operation ShorsAlgorithmClassical(N : Int) : (Int, Int) {
        // ...
        return (0,0);
    }

    //////////////////////////////////////////////////////////////////
    // Part II. Quantum Implementation of Order Finding
    //////////////////////////////////////////////////////////////////

    // The next step is to implement order finding using a quantum operation.

    // Task 2.1. Oracle
    // The first part of this is to write an oracle that represents the operation behind order finding. For this we need a quantum oracle
    // that carries out the following transformation:
    // $$ U|y\rangle \equiv |a y (\text{mod } N) \rangle$$

    // The algorithm will later rely on using quantum phase estimation (QFE) using this oracle, so we will need to apply this oracle 
    // multiple times, so the final oracle we want is:
    // $$ U^\text{power}|y\rangle \equiv |a^\text{power} y(\text{mod } N)\rangle $$

    // Input:
    //     1. A positive integer $a$
    //     2. A positive, relatively prime integer $N$
    //     3. A quantum register of the size of the number of bits required to express $N$ for the oracle to act on
    // Goal:
    //     Apply the above quantum oracle to the state $\text{power}$ times, resulting in $|y\rangle \to |a^\text{power} y(\text{mod } N)\rangle$
    operation OrderFindingOracle(a : Int, N : Int, power : Int, target : Qubit[]) : Unit is Adj+Ctl {
        // ...
    }

    // Task 2.2. We can define one of the eigenvectors for the order finding oracle with: 
    // $$ |\psi_1\rangle = \frac{1}{\sqrt{r}} \sum_{j=0}^{r-1} e^{-2\pi i \left(\frac{1}{r}\right)j} |a^j \text{mod} N \rangle$$
    // Or more generally the eigenvectors are:
    // $$ |\psi_k\rangle = \frac{1}{\sqrt{r}} \sum_{j=0}^{r-1} e^{-2\pi i \left(\frac{k}{r}\right)j} |a^j \text{mod} N \rangle$$
    // With eigenvalue:
    // $$ U|\psi_k \rangle = e^{-2\pi i \left(\frac{k}{r}\right)} | \psi_k \rangle $$

    // However, when we add up all $r$ eigenvectors, we get:
    // $$ \frac{1}{\sqrt{r}} \sum_{k=1}^{r} | \psi_k \rangle
    // = \frac{1}{r} \sum_{k=1}^{r} \sum_{j=0}^{r-1} e^{-2\pi i \left(\frac{k}{r}\right)j}|a^j \text{mod} N \rangle = |1\rangle$$

    // So, if we prepare the state $|1\rangle$ we can operate on it as the combination of all of the unknown eigenvalues and eigenvectors.
    
    // Input:
    //    A register in the |0> state
    // Goal:
    //    A register in the |1> state
    operation PrepareEigenstate(eigenstate : Qubit[]) : Unit is Adj+Ctl {
        //... 
    }

    // Task 2.3 Applying QFE to find the order

    // When we perform Quantum Phase Estimation on a unitary and it's eigenvector, the result is the $\theta$ value assocated with the eigenvalue where:
    // $$ U|\psi\rangle = e^{2\pi i\theta}|\psi\rangle $$

    // So, when we operate on the $|1\rangle$ state, which is the superposition of all of the (currently unknown) eigenvectors, the result will be the 
    // superposition of all of the results associated with all eigenvectors.

    // As the eigenvalues of each eigenvector are:
    // $$ U|\psi_k\rangle = e^{-2\pi i \left(\frac{k}{r}\right)} | \psi_k \rangle$$

    // So, the QPE result associated with the $k$th eigenvector will be:
    // $$ \theta_k = - \frac{k}{r} $$ 

    // So, when applying QPE to the $|1\rangle$ state, the result will be the superposition of the states, so:
    // $$ \theta = - \sum_{k=1}^r \frac{k}{r} $$

    // Mesuring the state will collapse the superposition, so we we get one of the $\frac{k}{r}$ states, or more precisely, the $k$ value associated with this state.

    // For this task write an operation that applys the quantum phase estimation and measures out an integer $k$ from the system.

    // Input:
    //     1. A [DiscreteOracle](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.oracles.discreteoracle) from the Oracles 
    //        library which is an oracle that takes an integer power and an array of quibits and applys the oracle power times
    //     2. An eigenstate register pre-prepared in the $|1\rangle$ state, and a result register in the $|0\rangle$ state, with some
    //        aribitrary number of bits of precision in the result.
    // Goal:    
    //     Either zero or a vaild $k$ value depending on the result of mesuring the quantum phase operation. The state of the qubits at the end does not matter.
    operation ApplyQuantumPhaseEstimation(oracle : DiscreteOracle, eigenstate : Qubit[], result : Qubit[]) : Int {
        // ...
        return 0;
    }

    // ### Task 2.4 Converting the QFE mesurement result to an order
    // While we have can now calculate a $k$ value, we still need to derive a value of $r$ from this.
    // Given we know that the number of bits of precision of the result register given, we can get the fraction $\frac{k}{r}$ 
    // from $\frac{k}{2^\text{N precision bits}}$, simplified down to a form such that $r < N$.
    // Input:
    //     1. A result $k$ output from the QPE operation above
    //     2. The number of bits of precision the measurement was carried out with, and the $N$ value being factorised.
    // Goal:
    //     An $r < N$ value such that $\frac{k}{r}$ is a close (or exact) approximation of $\frac{\text{phaseResult}}{2^\text{bitsPrecision}}$.
    //     Make sure the value returned is positive.
    operation PhaseResultToOrder(phaseResult : Int, bitsPrecision : Int, N : Int) : Int {
        //...
        return 0;
    }

    // ### Task 2.5 Quantum Order Finder

    // Now we have all of the peices to use a quantum algorithm to calculate the order of two numbers $a$ and $N$, we just need to combine it 
    // all together. The overall order finder needs to:

    // 1. Allocate and prepare a eigenstate register with the bit size of $N$
    // 2. Set up a result register to hold the QPE result. The test use a size $2n + 1$ where $n$ is the bit size of $N$
    // 3. Calculate the result from QFE
    // 4. Calculate the order based on this result
    // 5. Check (classically) if the result is a valid order result
    // 6. If it's valid return the value, otherwise try again

    // Input:
    //     1. Positive integer $a$
    //     2. Positive coprime integer $N$
    // Goal:
    //     The order of $a, N$
    operation FindOrderQuantum(a : Int, N : Int) : Int {
        // ...
        return 0;
    }

    // Task 2.6. Implementing a Quantum Shor's Algorithm
    
    // Finally, just use the quantum order finding oracle to define a quantum Shor's Algorithm!

    // Input:
    //     An integer $N$ to be factored
    // Goal:
    //     A tuple of integers representing the factors of $N$, found using the quantum order finding
    operation ShorsAlgorithmQuantum(N : Int) : (Int, Int) {
        //...
        return (0,0);
    }


}