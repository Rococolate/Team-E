## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


### 优化前
| time   | transaction cost | execution cost | 
| ------ | ---------------- | -------------- |
| 1      |    22971 gas     |    1699 gas    |
| 2      |    23759 gas     |    2487 gas    |
| 3      |    24547 gas     |    3275 gas    |
| 4      |    25335 gas     |    4063 gas    |
| 5      |    26123 gas     |    4851 gas    |
| 6      |    26911 gas     |    5639 gas    |
| 7      |    27699 gas     |    6427 gas    |
| 8      |    28487 gas     |    7215 gas    |
| 9      |    29275 gas     |    8003 gas    |
| 10     |    30063 gas     |    8791 gas    |

gas消耗递增，是因为数组长度增加调用calculateRunway函数时循环次数增加，增加了运算量。

### 优化后

| time   | transaction cost | execution cost | 
| ------ | ---------------- | -------------- |
| 1      |    22122 gas     |    850 gas    |
| 2      |    22122 gas     |    850 gas    |
| 3      |    22122 gas     |    850 gas    |
| 4      |    22122 gas     |    850 gas    |
| 5      |    22122 gas     |    850 gas    |
| 6      |    22122 gas     |    850 gas    |
| 7      |    22122 gas     |    850 gas    |
| 8      |    22122 gas     |    850 gas    |
| 9      |    22122 gas     |    850 gas    |
| 10     |    22122 gas     |    850 gas    |


