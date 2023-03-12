import numpy as np
import pyopencl as cl
import hashlib

# 将字符串转换为byte字符串
def str_to_bytes(s):
    return bytes(s, 'utf-8')

# 计算SHA256哈希值
def sha256(s):
    m = hashlib.sha256()
    m.update(s)
    return m.hexdigest()


# hex_str = "4120"
# byte_str = bytes.fromhex(hex_str)
# my_str = byte_str.decode('utf-8')
# # 创建一个包含密钥的字符串
# key_str = my_str
# key_len = len(key_str)

# 将字符串转换为byte字符串
# key_bytes = str_to_bytes(key_str)

key_str = ''
hex_str = '7e5d84f2dc1a1167fa188d25ba76ca1b73026656'

key_len = len(hex_str) / 2
print(key_len, len(hex_str))
key_bytes = bytes.fromhex(hex_str)
print(key_bytes)

# 计算SHA256哈希值
cpu_key_bytes = bytes.fromhex('41'+hex_str)
hash_value = sha256(cpu_key_bytes)
print(hash_value)
hash_value = sha256(bytes.fromhex(hash_value))

# 将哈希值转换为一个numpy数组
# hash_data = np.frombuffer(hash_value, dtype=np.uint8)

# 创建一个OpenCL上下文和命令队列
ctx = cl.create_some_context()
queue = cl.CommandQueue(ctx)


# Compile the kernel
kernel = open('sha256.cl').read()
program = cl.Program(ctx, kernel).build()

# 创建OpenCL缓冲区对象
mf = cl.mem_flags
key_buffer = cl.Buffer(ctx, mf.READ_ONLY | mf.COPY_HOST_PTR, hostbuf=key_bytes)
result_buffer = cl.Buffer(ctx, mf.WRITE_ONLY, 64)

# 调用内核
global_size = (1,)
program.sha256single_kernel(queue, global_size, None, np.uint32(key_len), key_buffer, result_buffer)

# 读取输出缓冲区中的数据
result_data = np.empty(20, dtype=np.uint8)
cl.enqueue_copy(queue, result_data, result_buffer)

# 将结果转换为字符串
my_str = "".join([format(b, '02x') for b in result_data])
# my_str = result_data.tobytes().decode('utf-8')

# 打印结果
print("Key:", key_str)
print("Hex:" , hex_str)
print("CPU:", '41'+ hex_str.lower() + hash_value[0:8])
print("HAS:", my_str)