1. 计算源语言文件的哈希，写入 

# 可以用在一个整数字面量后面加 n 的方式定义一个 BigInt ，如：10n，或者调用函数 BigInt()（但不包含 new 运算符）并传递一个整数值或字符串值。

```
.cache.${lang}.js

export hash cache = {
  file : [size, time, hash(128位数字，以n结尾)]
}
```

如果原语言不变，就无需重新翻译

2. 出错重试

3. 每个语言对的缓存
