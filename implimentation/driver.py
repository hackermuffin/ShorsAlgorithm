import sys
import random
from math import gcd

import qsharp
from PeriodFinder import FindPeriod
from QSharp.Chapter12 import EstimatePeriod


def main():
    N = readArgument()
    print(f"Starting to factorise {N}...")
    specialCases(N)
    generalCase(N)
    

def readArgument():
    # Pull in value to factoris from first CLI argument
    if len(sys.argv) <= 1:
        raise ValueError('Please provide a nubmer to factorise')
    try:
        N = int(sys.argv[1])
    except ValueError:
        raise ValueError('Please provide an integer value to factorise')
    return N

def specialCases(N):
    # check if N is even
    print(f"Checking if {N} is even...")
    if (N%2 == 0):
        print(f"{N} is even!")
        foundFactors(N,2,int(N/2))
    print(f"{N} is not even. Checking if {N} is prime...")
    # check if N is prime TODO
    if False:
        raise ValueError(f'{N} is prime and cannot be factored')
    print(f"{N} is not prime. Starting general factorisation algorithm...")


def generalCase(N):
    while True:
        a = random.randint(2,N-1)
        print(f"Picked random cofactor {a}")
        gcd_result = gcd(a,N)
        if gcd_result > 1:
            print(f"Random cofactor {a} is a factor of {N}!")
            foundFactors(N, gcd_result, int(N/gcd_result))
        print(f"Random cofactor {a} is not a factor of {N}. Starting factorisation...")
        r = findOrder(a, N)
        print(f"Order of {a} mod {N} is {r}.")
        if (r%2 == 0):
            print(f"Order {r} is even. Calculating a likely factor...")
            x = (a**int(r/2) - 1) % N
            print(f"Testing likely factor {x}...")
            gcd_result = gcd(x,N)
            if (gcd_result > 1):
                foundFactors(N,gcd_result,int(N/gcd_result))
            else:
                print(f"Likely factor {x} was not a factor. Starting again with a new cofactor.")
        else:
            print(f"Order {r} is not even. Starting again with a new cofactor.")

def findOrder(a, N):
    result = None
    while (not isinstance(result,int)):
        return FindPeriod.simulate(a=a,N=N)
        # result = (EstimatePeriod.simulate(generator=a,modulus=N))
    return result

def classicalOrderFinder(a, N):
    r = 1
    while True:
        if (a**r)%N == 1:
            return r
        r += 1

def foundFactors(N,p,q):
    print(f"Factors of {N} found: {p}, {q}")
    sys.exit()


if __name__ == "__main__":
    main()