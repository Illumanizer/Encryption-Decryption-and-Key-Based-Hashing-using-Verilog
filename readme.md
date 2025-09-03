# 🔐 SPN Cipher – Encrypt / Decrypt / Hash with Verification  

This project implements a lightweight **Substitution–Permutation Network (SPN)** style cipher in **SystemVerilog**, along with modules for:  
- **Encryption**  
- **Decryption**  
- **Key-based Hashing**  
- **Full Verification (Decrypt + Re-encrypt + Hash)**  
- **Self-checking Testbenches (hard-coded + randomized)**  



---

## 📂 Project Structure  

```text
├── src/
│   ├── encrypt.sv          # Encryption module
│   ├── decrypt.sv          # Decryption module (inverse of encrypt)
│   ├── hash.sv             # Hash function (key-based mixing on ciphertext)
│   ├── verify.sv           # Verification module (decrypt, re-encrypt, hash checks)
│   ├── helper.sv           # Helper logic (if required by modules)
│   ├── sboxes.sv           # S-box + inverse S-box logic with $readmemh
│   ├── sbox.mem            # Lookup table for S-box
│   └── invsbox.mem         # Lookup table for inverse S-box
│
├── tb/
│   ├── tb_encrypt.sv       # Testbench for encryption
│   ├── tb_decrypt.sv       # Testbench for decryption
│   ├── tb_decrypt_hash.sv  # Testbench for decrypt + hash consistency
│   ├── tb_verify.sv        # Testbench for verify module (fixed vectors)
│   └── tb_verify_rand.sv   # Randomized testbench for verify module
│
├── build/                  # Compiled simulation outputs (.vvp files)
├── data/                   # Memory files (S-box tables)
│   ├── sbox.mem
│   └── invsbox.mem
│
├── README.md
└── .gitignore
```

## ⚙️ Program Flow  

### 🔸 Encryption
- **Input:** 8-bit plaintext  
- **Process:**  
  - Byte → S-box lookup  
  - Permutation / key mixing  
- **Output:** 8-bit ciphertext  

---

### 🔸 Decryption
- **Input:** 8-bit ciphertext  
- **Process:**  
  - Byte → inverse S-box lookup  
  - Reverse permutation / key mixing  
- **Output:** 8-bit plaintext  

---

### 🔸 Hash
- **Input:** Encrypted byte (`enc_in`)  
- **Process:** Lightweight key-based mixing, nibble-swaps, and shifts  
- **Output:** 8-bit hash (used for integrity check)  

---

### 🔸 Verify
- **Inputs:**  
  - `plain` → expected plaintext  
  - `enc_in` → ciphertext under test  
  - `ref_hash` → reference hash (golden value)  

- **Outputs:**  
  - `valid_flag` → HIGH if `decrypt(enc_in) == plain`  
  - `enc_match` → HIGH if `encrypt(decrypt(enc_in)) == enc_in`  
  - `hash_match` → HIGH if `hash(enc_in) == ref_hash`  

The **Verify** module ensures full consistency by checking both **decryption correctness** and **roundtrip re-encryption**, as well as **hash validation**.  

---

## 🔄 Verification Flow  

```text
             +-----------------+
 enc_in ---> |     decrypt     | ---> dec_plain
             +-----------------+
                       |
                       | compare with expected plain
                       v
                  valid_flag
                       |
                       v
             +-----------------+
             |     encrypt     | ---> reenc
             +-----------------+
                       |
                       | compare with original enc_in
                       v
                   enc_match

 enc_in ---> +-----------------+
             |      hash       | ---> hash_out
             +-----------------+
                       |
                       | compare with reference hash
                       v
                   hash_match

```
## 🧪 Testbenches  

Each testbench is **self-checking** using `assert` + `$fatal` for automated verification:

- **`tb_encrypt.sv`** — Verifies encryption against known plaintext/ciphertext pairs  
- **`tb_decrypt.sv`** — Verifies decryption against fixed plaintext vectors  
- **`tb_decrypt_hash.sv`** — Tests decryption + hash operations compared to golden (reference) values  
- **`tb_verify.sv`** — Fixed test vectors for the `verify` module (checks decryption, re-encryption, and hash consistency)  
- **`tb_verify_rand.sv`** — Randomized testbench for the `verify` module using golden reference models  



## ▶️ Running the Project  

### 1. Compile  
```bash
iverilog -g2012 -o build/tb_verify.vvp src/*.sv tb/tb_verify.sv
```
### 2) Run
```bash
vvp build/tb_verify.vvp
```

### (optional) 
You can also fire random test cases by running `tb_verify_rand.sv`
```bash
iverilog -g2012 -o build/tb_verify_rand.vvp src/*.sv tb/tb_verify_rand.sv
vvp build/tb_verify_rand.vvp

```

### 3) Waveforms

Add this to your testbench:
```bash
initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0, tb_flags);
end
```

Then:
```bash
vvp build/tb_flags.vvp
gtkwave wave.vcd
```

---

# ▶️ Running Each Testbench  

You can run individual testbenches using the following commands (from project root):  


### 🔒 encrypt
```bash
iverilog -g2012 -o build/tb_encrypt.vvp src/*.sv tb/tb_encrypt.sv && vvp build/tb_encrypt.vvp
```

### 🔓 decrypt
```bash
iverilog -g2012 -o build/tb_decrypt.vvp src/*.sv tb/tb_decrypt.sv && vvp build/tb_decrypt.vvp
```

### 🔓+🔑 decrypt + hash
```bash
iverilog -g2012 -o build/tb_decrypt_hash.vvp src/*.sv tb/tb_decrypt_hash.sv && vvp build/tb_decrypt_hash.vvp
```

### 🚩 verify (valid_flag, enc_match & hash_match)
```bash
iverilog -g2012 -o build/tb_verify.vvp src/*.sv tb/tb_verify.sv && vvp build/tb_verify.vvp
```

### 🔄 🚩 random verify 
```bash
iverilog -g2012 -o build/tb_verify_rand.vvp src/*.sv tb/tb_verify_rand.sv && vvp build/tb_verify_rand.vvp
```
---

## ✅ Features

- **SystemVerilog-2012** compliant modules and testbenches
- **`$readmemh`** support for S-box / inverse S-box loading from `.mem` files
- **Randomized testing** with timing spacing for waveform readability
- **Flags module** exposes `valid_flag`, `enc_match` and `hash_match` status signals
- **Comprehensive assertions** across all testbenches for automated pass/fail verification

