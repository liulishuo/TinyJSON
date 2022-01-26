# TinyJSON

A Wrapping of JSON data in Swift.

Faster and  less memory cost than SwiftyJSON.

###  [TinyJSON对比SwiftyJSON的性能测试](https://github.com/liulishuo/TinyJSONMetrics) 

### 为什么比 SwiftyJSON 效率高

####  SwiftyJSON 的缺点

- SwiftyJSON没有真正解析 JSON 对象，它将 JSON 对象按类型储存在某一个属性下，

  还需要一个属性标识 JSON 对象的类型，由于 JSON 对象只可能是6种类型中的一种，这个 JSON 类型变量浪费了太多内存。

  ```
  MemoryLayout<JSON>.size 
  
  51
  
  MemoryLayout<JSON>.alignment
  
  8
  
  MemoryLayout<JSON>.stride
  
  56
  
  0x7ffeefbff428: 0x00007fff816b8be8 0x00000001007859d0
  
                    rawArray            rawDictionary
  
  0x7ffeefbff438: 0x0000000000000000 0xe000000000000000
  
                              rawString
  
  0x7ffeefbff448: 0x1ab4dcef7383f1ab 0x00007fff807f3eb0
  
                     rawNumber         rawNull
  
  0x7ffeefbff458: 0x0000000000060400 
  
                error ｜ type ｜rawBool  
  ```

  

  例如如果 JSON 对象是字典类型，不考虑堆上开辟的空间，光 SwiftyJSON 类型的变量就起码浪费了 41Byte 的空间。

- 由于 SwiftyJSON 对象基本上等价于原样存储（遍历所有JSON节点，将OC容器类型转换为Swift容器类型），容器内的元素类型不确定，为 Any 类型，造成了存储空间的浪费，经测试 Any 类型相比于非 Any 类型，内存占用大概多6倍。

- 由于容器内存储的是不确定类型的原始数据，所以每次取值时都需要做计算，浪费算力。

  

#### TinyJSON 的特点

- 每个 JSON 节点都被封装成 TinyJSON 枚举。

```swift
MemoryLayout<TinyJSON>.size
17
MemoryLayout<TinyJSON>.alignment
8
MemoryLayout<TinyJSON>.stride
24

0x7ffeefbff408: 0x0000000000000009 0x0000000000000001
                object || array || string || number || bool
0x7ffeefbff418: 0x0000000000000003
			      type
```

- 所有元素都有明确的类型，不存在 Any 类型，节省内存。
- 取值不需要重复计算。





 



