#ifndef HE_H
#define HE_H

#include <openfhe.h>

using namespace lbcrypto;

class HE {
public:
    // Constructor for BFV or BGV mode, but default here is BFV.
    HE(const std::string& mode    = "BFV",
       int64_t          modulus = 65537,
       int32_t          depth   = 20) 
    {
        if (mode == "BFV") {
            CCParams<CryptoContextBFVRNS> parameters;
            parameters.SetPlaintextModulus(modulus);
            parameters.SetMultiplicativeDepth(depth);
            std::cout  << "Parameters: " << parameters << std::endl;
            cc = GenCryptoContext(parameters);
        } else if (mode == "BGV") {
            CCParams<CryptoContextBGVRNS> parameters;
            parameters.SetPlaintextModulus(modulus);
            parameters.SetMultiplicativeDepth(depth);
            std::cout  << "Parameters: " << parameters << std::endl;
            cc = GenCryptoContext(parameters);
        } else {
            throw std::runtime_error("Invalid scheme mode: " + mode);
        }

        cc->Enable(PKE);
        cc->Enable(KEYSWITCH);
        cc->Enable(LEVELEDSHE);
        cc->Enable(ADVANCEDSHE);

        keyPair = cc->KeyGen();
        cc->EvalMultKeyGen(keyPair.secretKey);
        cc->EvalRotateKeyGen(keyPair.secretKey, {1, 2, 4, 8});

        // Print some approximate stats (optional)
        // Note: in BFV/BGV, GetPlaintextModulus() is not the same as ciphertext modulus,
        // but we replicate the Python code's approximate logging.
        double logPtMod = std::log2(cc->GetCryptoParameters()->GetPlaintextModulus());
        double logRing  = std::log2(cc->GetRingDimension());
        double sizeMB   = (static_cast<double>(1ULL << static_cast<size_t>(std::round(logRing))) 
                         * logPtMod * 2.0) / (1ULL << 23);

        std::cout << "Mode: " << mode << std::endl;
        std::cout << "log2 q = " << log2(cc->GetCryptoParameters()->GetElementParams()->GetModulus().ConvertToDouble())
              << std::endl;
        std::cout << "Plaintext Modulus, p (bit) approx: " << logPtMod << std::endl;
        std::cout << "Ring Dimension, N (log) approx:    " << logRing << std::endl;
        std::cout << "CTXT Size in MB approx:         " << sizeMB << std::endl;
    }

    int64_t ringDim = 32768;
    int64_t prime = 65537;

    // Packing/Encryption/Decryption
    Plaintext packing(const std::vector<int64_t>& vals) {
        return cc->MakePackedPlaintext(vals);
    }

    Ciphertext<DCRTPoly> encrypt(const Plaintext& pt) {
        return cc->Encrypt(keyPair.publicKey, pt);
    }

    Plaintext decrypt(const Ciphertext<DCRTPoly>& ct) {
        Plaintext result;
        cc->Decrypt(keyPair.secretKey, ct, &result);
        return result;
    }

    // Basic arithmetic
    Ciphertext<DCRTPoly> add(const Ciphertext<DCRTPoly>& a,
                             const Ciphertext<DCRTPoly>& b) {
        return cc->EvalAdd(a, b);
    }

    Ciphertext<DCRTPoly> sub(const Ciphertext<DCRTPoly>& a,
                             const Ciphertext<DCRTPoly>& b) {
        return cc->EvalSub(a, b);
    }

    Ciphertext<DCRTPoly> mult(const Ciphertext<DCRTPoly>& a,
                              const Ciphertext<DCRTPoly>& b) {
        return cc->EvalMult(a, b);
    }

    Ciphertext<DCRTPoly> mult(const Ciphertext<DCRTPoly>& a,
                              const Plaintext& b) {
        return cc->EvalMult(a, b);
    }

    Ciphertext<DCRTPoly> square(const Ciphertext<DCRTPoly>& x) {
        return cc->EvalSquare(x);
    }

    Ciphertext<DCRTPoly> sub(const Plaintext& pt, 
                             const Ciphertext<DCRTPoly>& ct) {
        return cc->EvalSub(pt, ct);
    }

    Ciphertext<DCRTPoly> rotate(const Ciphertext<DCRTPoly> &ct,
                                const int rotIdx) {
        return cc->EvalRotate(ct, rotIdx);
    }

    Ciphertext<DCRTPoly> addmany(
        const std::vector<Ciphertext<DCRTPoly>> &ct
    ) {
        return cc->EvalAddMany(ct);
    }    

    Ciphertext<DCRTPoly> multmany(
        const std::vector<Ciphertext<DCRTPoly>> &ct
    ) {
        return cc->EvalMultMany(ct);
    }    

    // (Optional) Rescale or compress if needed – not shown here
    // ...

private:
    CryptoContext<DCRTPoly> cc;
    KeyPair<DCRTPoly> keyPair;;
};

#endif