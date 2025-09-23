package LAB5;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.Scanner;
import java.security.SecureRandom;

public class ElGamalUsingG {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        SecureRandom random = new SecureRandom();

        // Step 1: Input prime number q
        System.out.print("Enter a prime number (q): ");
        BigInteger q = new BigInteger(scanner.nextLine());
        int qInt = q.intValue();

        if (!isPrime(qInt)) {
            System.out.println("Not a prime number.");
            scanner.close();
            return;
        }

        // Step 2: Find primitive roots modulo q
        System.out.println("Finding primitive roots modulo " + qInt + "...");
        HashSet<Integer> primitiveRoots = new HashSet<>();
        for (int i = 2; i < qInt; i++) {
            if (isPrimitiveRoot(i, qInt)) {
                primitiveRoots.add(i);
            }
        }

        if (primitiveRoots.isEmpty()) {
            System.out.println("No primitive roots found for q = " + qInt);
            scanner.close();
            return;
        }

        System.out.println("Primitive roots modulo " + qInt + ": " + primitiveRoots);

        // Step 3: Choose a valid primitive root g
        int gInt;
        while (true) {
            System.out.print("Enter one of the above primitive roots to use (g): ");
            gInt = Integer.parseInt(scanner.nextLine());
            if (primitiveRoots.contains(gInt)) {
                break;
            } else {
                System.out.println("Invalid choice. Please select a primitive root from the list.");
            }
        }

        BigInteger g = BigInteger.valueOf(gInt);
        System.out.println("Using primitive root g = " + g);

        // Step 4: Generate private key X_A and public key Y_A
        System.out.print("Enter private key X_A (1 < X_A < q - 1): ");
        BigInteger XA = new BigInteger(scanner.nextLine());
        BigInteger YA = g.modPow(XA, q); // Y_A = g^X_A mod q

        System.out.println("Public Key of A: {q = " + q + ", g = " + g + ", Y_A = " + YA + "}");

        // Step 5: Input message M
        System.out.print("Enter message M (0 <= M < q): ");
        BigInteger M = new BigInteger(scanner.nextLine());
        if (M.compareTo(BigInteger.ZERO) < 0 || M.compareTo(q) >= 0) {
            System.out.println("Message must be in range 0 ≤ M < q.");
            scanner.close();
            return;
        }

        // Step 6: Choose random ephemeral key k
        BigInteger k;
        do {
            k = new BigInteger(q.bitLength() - 1, random);
        } while (k.compareTo(BigInteger.ONE) < 0 || k.compareTo(q.subtract(BigInteger.ONE)) > 0);

        // Step 7: Encrypt
        BigInteger K = YA.modPow(k, q); // K = Y_A^k mod q
        BigInteger C1 = g.modPow(k, q); // C1 = g^k mod q
        BigInteger C2 = K.multiply(M).mod(q); // C2 = K * M mod q

        System.out.println("\nEncrypted Ciphertext:");
        System.out.println("C1: " + C1);
        System.out.println("C2: " + C2);

        // Step 8: Decrypt
        BigInteger K_recovered = C1.modPow(XA, q); // K = C1^X_A mod q
        BigInteger K_inv = K_recovered.modInverse(q); // K^-1 mod q
        BigInteger M_decrypted = C2.multiply(K_inv).mod(q); // M = C2 * K^-1 mod q

        System.out.println("\nDecrypted Message: " + M_decrypted);

        // Step 9: Verification
        if (M_decrypted.equals(M)) {
            System.out.println("\n Verification Successful: Decrypted message matches original.");
        } else {
            System.out.println("\n Verification Failed: Decrypted message does not match original.");
        }

        scanner.close();
    }

    // Primitive root check using HashSet
    static boolean isPrimitiveRoot(int g, int p) {
        HashSet<Integer> remainders = new HashSet<>();
        int result = 1;
        for (int i = 1; i < p; i++) {
            result = (result * g) % p;
            if (remainders.contains(result)) return false;
            remainders.add(result);
        }
        return remainders.size() == p - 1;
    }

    // Simple primality test
    static boolean isPrime(int num) {
        if (num <= 1) return false;
        for (int i = 2; i <= Math.sqrt(num); i++) {
            if (num % i == 0) return false;
        }
        return true;
    }
}

