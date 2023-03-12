__kernel void sha256(__global const uint *input, __global uchar *output) {
  const uint a[] = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19};
  const uint k[] = {
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
      0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
      0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
      0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
      0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
      0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
      0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
      0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
      0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};
  uint w[64];
  uint h[8];
  uint temp1, temp2, maj, ch;
  uint s0, s1, sigma0, sigma1;
  int i, j;

  // initialize hash values
  for (i = 0; i < 8; i++) {
    h[i] = a[i];
  }
  // prepare message schedule
  w[0] = input[0];
  w[1] = input[1];
  w[2] = 0x80000000;
  w[15] = 64;
  for (i = 16; i < 64; i++) {
    s0 = ROTR(w[i - 15], 7) ^ ROTR(w[i - 15], 18) ^ (w[i - 15] >> 3);
    s1 = ROTR(w[i - 2], 17) ^ ROTR(w[i - 2], 19) ^ (w[i - 2] >> 10);
    w[i] = w[i - 16] + s0 + w[i - 7] + s1;
  }

  // main loop
  for (i = 0; i < 64; i++) {
    s0 = ROTR(h[0], 2) ^ ROTR(h[0], 13) ^ ROTR(h[0], 22);
    maj = (h[0] & h[1]) ^ (h[0] & h[2]) ^ (h[1] & h[2]);
    temp2 = s0 + maj;
    s1 = ROTR(h[4], 6) ^ ROTR(h[4], 11) ^ ROTR(h[4], 25);
    ch = (h[4] & h[5]) ^ (~h[4] & h[6]);
    temp1 = h[7] + s1 + ch + k[i] + w[i];
    h[7] = h[6];
    h[6] = h[5];
    h[5] = h[4];
    h[4] = h[3] + temp1;
    h[3] = h[2];
    h[2] = h[1];
    h[1] = h[0];
    h[0] = temp1 + temp2;
  }

  // output hash
  for (i = 0; i < 8; i++) {
    output[i * 4 + 0] = (h[i] >> 24) & 0xFF;
    output[i * 4 + 1] = (h[i] >> 16) & 0xFF;
    output[i * 4 + 2] = (h[i] >> 8) & 0xFF;
    output[i * 4 + 3] = h[i] & 0xFF;
  }
}

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))