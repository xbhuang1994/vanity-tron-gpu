# uint_value = 2750873409
# hex_string = hex(uint_value)

# print(uint_value,hex_string)  # Output: 0x40d3f57b

hex_str = '41ffd01b23c8d75ca029ce75bc4f2f9cdabbccdd' # 16进制字符串
bys = bytes.fromhex(hex_str)
for b in bys:
    print(hex(b))


# hex_string = "41ffd4d3"
# integer = int(hex_string,16)
# print(integer)