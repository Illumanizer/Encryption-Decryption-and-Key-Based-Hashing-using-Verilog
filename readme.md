# 🔐 SPN Cipher – Encrypt / Decrypt / Hash with Verification  

This project implements a lightweight **Substitution–Permutation Network (SPN)** style cipher in **SystemVerilog**, along with modules for:  
- **Encryption**  
- **Decryption**  
- **Key-based Hashing**  
- **Verification Flags**  
- **Self-checking Testbenches**  

It is intended as an educational hardware design exercise to explore block ciphers, reversible logic, and testbench automation.  

---

## 📂 Project Structure  

```text
├── src/
│   ├── encrypt.sv          # Encryption module
│   ├── decrypt.sv          # Decryption module (inverse of encrypt)
│   ├── hash.sv             # Hash function (key-based mixing on ciphertext)
│   ├── flags.sv            # Flag generator (valid_flag, hash_match)
│   ├── sboxes.sv           # S-box + inverse S-box logic with $readmemh
│   ├── sbox.mem            # Lookup table for S-box
│   └── invsbox.mem         # Lookup table for inverse S-box
│
├── tb/
│   ├── tb_decrypt.sv       # Testbench for decryption module
│   ├── tb_decrypt_hash.sv  # Testbench for decrypt + hash consistency
│   ├── tb_roundtrip.sv     # Roundtrip test (encrypt→decrypt and decrypt→encrypt)
│   ├── tb_roundtrip_rand.sv# Randomized roundtrip tests
│   └── tb_flags.sv         # Testbench for flag verification module
│
└── README.md
```

## ⚙️ Program Flow  

### 🔸 Encryption
- Input: 8-bit plaintext  
- Process:  
  - Byte → S-box lookup  
  - Permutation / key mixing  
- Output: 8-bit ciphertext  

### 🔸 Decryption
- Input: 8-bit ciphertext  
- Process:  
  - Byte → inverse S-box lookup  
  - Reverse permutation / key mixing  
- Output: 8-bit plaintext  

### 🔸 Hash
- Input: Encrypted byte (`enc_in`)  
- Process: Lightweight key-based mixing, nibble-swaps, and shifts  
- Output: 8-bit hash (used for integrity check)  

### 🔸 Flags
- Inputs:  
  - `plain` → expected plaintext  
  - `enc_in` → ciphertext  
  - `ref_hash` → reference hash (golden hash)  
- Outputs:  
  - `valid_flag` → HIGH if decrypt(enc_in) == plain  
  - `hash_match` → HIGH if hash(enc_in) == ref_hash  

---

## 🔄 Verification Flow  

```text
            +-----------------+
 enc_in --->|     decrypt     |---> dec_plain
            +-----------------+
                     |
                     | compare with expected plain
                     v
                valid_flag

 enc_in --->+-----------------+
            |      hash       |---> hash_out
            +-----------------+
                     |
                     | compare with reference hash
                     v
                 hash_match
```
## 🧪 Testbenches

Each testbench is self-checking using `assert` + `$fatal` for automated verification:

- **`tb_decrypt.sv`** — Verifies decryption against fixed plaintext vectors
- **`tb_decrypt_hash.sv`** — Tests decryption + hash operations compared to golden (reference) values  
- **`tb_roundtrip.sv`** — Validates that `decrypt(encrypt(p)) == p` and `encrypt(decrypt(e)) == e`
- **`tb_roundtrip_rand.sv`** — Executes multiple random round-trips with small delays for clean waveforms
- **`tb_flags.sv`** — Asserts `valid_flag` and `hash_match` signals from the flags module


## ▶️ Running the Project  

### 1. Compile  
```bash
# from project root
iverilog -g2012 -o build/tb_flags.vvp src/*.sv tb/tb_flags.sv
```
### 2) Run
```bash
vvp build/tb_flags.vvp
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

### 🔄 roundtrip (encrypt ↔ decrypt)
```bash
iverilog -g2012 -o build/tb_roundtrip.vvp src/*.sv tb/tb_roundtrip.sv && vvp build/tb_roundtrip.vvp 
```
### 🚩 flags (valid_flag & hash_match)
```bash
iverilog -g2012 -o build/tb_flags.vvp src/*.sv tb/tb_flags.sv && vvp build/tb_flags.vvp
```
---

## ✅ Features

- **SystemVerilog-2012** compliant modules and testbenches
- **`$readmemh`** support for S-box / inverse S-box loading from `.mem` files
- **Randomized testing** with timing spacing for waveform readability
- **Flags module** exposes `valid_flag` and `hash_match` status signals
- **Comprehensive assertions** across all testbenches for automated pass/fail verification

## 🚀 Future Improvements

- [ ] Parameterize block/key size for flexibility
- [ ] Implement multi-round SPN for enhanced diffusion/confusion
- [ ] Generate S-boxes algorithmically instead of static `.mem` files
- [ ] Add functional coverage and constrained random verification
- [ ] Implement coverage-driven verification methodology
