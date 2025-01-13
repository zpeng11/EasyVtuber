# To Know
基于Release版本v0.3, 测试平台为windows10 22H2, CPU Intel 10400f , GPU Nvidia 3060 12G，Nvidia 1660 Super 6G, ARC A770 16G， RX580 8G.  
Jpeg compression 和 Input Simplify 都 medium, debug input 不使用eyebrow参数, 帧数限制60fps  
观察开始后约5-10秒的数值记录,不考虑长期缓存效果(没时间测)

GPU | model | VRAM Cache | RAM Cache | Interpolation | SR | Frame Rate | GPU Usage
:---: | :---: | :---: | :---: | :---: | :---: | :---:  | :---:
A770 | sepe_half | N/A | No | No | No | 33fps | 97%
A770 | sepe_full | N/A | No | No | No | 48fps | 97%
A770 | stan_half | N/A | No | No | No | 27fps | 97%
A770 | stan_full | N/A | No | No | No | 29fps | 97%
A770 | sepe_half | N/A | 2GB | No | No | 30fps | 82%
A770 | sepe_full | N/A | 2GB | No | No | 43fps | 78%
A770 | stan_half | N/A | 2GB | No | No | 30fps | 82%
A770 | stan_full | N/A | 2GB | No | No | 23fps | 85%
A770 | sepe_full | N/A | No | No | x2_half | 17fps | 97%
A770 | sepe_full | N/A | No | No | x4_half | 29fps | 97%
A770 | sepe_full | N/A | No | No | x4_full | 25fps | 93%
A770 | sepe_full | N/A | No | x2_half | No | 60fps | 93%
A770 | sepe_full | N/A | No | x3_half | No | 60fps | 85%
A770 | sepe_full | N/A | No | x4_half | No | 60fps | 81%
-- | -- | --| --|--|--|--|--
RX580 | sepe_full | N/A | No | No | No | 12fps | 98%
RX580 | stan_full | N/A | No | No | No | 15fps | 98%
RX580 | sepe_full | N/A | 2GB | No | No | 11fps | 93%
RX580 | stan_full | N/A | 2GB | No | No | 13fps | 93%
RX580 | stan_full | N/A | No | No | x2_half | 10fps | 97%
RX580 | stan_full | N/A | No | No | x2_full | 10fps | 97%
RX580 | stan_full | N/A | No | No | x4_half | 11fps | 98%
RX580 | stan_full | N/A | No | No | x4_full | 11fps | 98%
RX580 | stan_full | N/A | No | x2_half | no | 22fps | 98%
RX580 | stan_full | N/A | No | x2_full | no | 22fps | 98%
RX580 | stan_full | N/A | No | x3_half | no | 28fps | 98%
RX580 | stan_full | N/A | No | x3_full | no | 28fps | 98%
RX580 | stan_full | N/A | No | x4_half | no | 33fps | 98%
RX580 | stan_full | N/A | No | x4_full | no | 33fps | 98%
-- | -- | --| --|--|--|--|--
1660s | sepe_half | No | No | No | No | 38fps | 95%
1660s | sepe_full | No | No | No | No | 28fps | 95%
1660s | stan_half | No | No | No | No | 21fps | 96%
1660s | stan_full | No | No | No | No | 12fps | 98%
1660s | sepe_half | 2GB | No | No | No | 39fps | 95%
1660s | sepe_full | 2GB | No | No | No | 28fps | 95%
1660s | stan_half | 2GB | No | No | No | 29fps | 96%
1660s | stan_full | 2GB | No | No | No | 12fps | 96%
1660s | sepe_half | 2GB | 2GB | No | No | 40fps | 75%
1660s | sepe_full | 2GB | 2GB | No | No | 24fps | 80%
1660s | stan_half | 2GB | 2GB | No | No | 26fps | 83%
1660s | stan_full | 2GB | 2GB | No | No | 12fps | 92%
1660s | sepe_half | No | No | No | x2_half | 23fps | 96%
1660s | sepe_half | No | No | No | x2_full | 18fps | 96%
1660s | sepe_half | No | No | No | x4_half | 23fps | 96%
1660s | sepe_half | No | No | No | x4_full | 26fps | 97%
1660s | sepe_half | No | No | x2_half | No | 63fps | 75%
1660s | sepe_half | No | No | x2_full | No | 63fps | 80%
1660s | sepe_half | No | No | x3_half | No | 63fps | 65%
1660s | sepe_half | No | No | x3_full | No | 64fps | 66%
1660s | sepe_half | No | No | x4_half | No | 64fps | 53%
1660s | sepe_half | No | No | x4_full | No | 64fps | 60%
-- | -- | --| --|--|--|--|--
3060 | sepe_half | No | No | No | No | 63fps | 62%
3060 | sepe_full | No | No | No | No | 59fps | 93%
3060 | stan_half | No | No | No | No | 63fps | 80%
3060 | stan_full | No | No | No | No | 31fps | 96%
3060 | sepe_half | 2GB | No | No | No | 63fps | 60%
3060 | sepe_full | 2GB | No | No | No | 60fps | 93%
3060 | stan_half | 2GB | No | No | No | 63fps | 76%
3060 | stan_full | 2GB | No | No | No | 33fps | 96%
3060 | sepe_half | 2GB | 2GB | No | No | 63fps | 58%
3060 | sepe_full | 2GB | 2GB | No | No | 46fps | 70%
3060 | stan_half | 2GB | 2GB | No | No | 43fps | 62%
3060 | stan_full | 2GB | 2GB | No | No | 27fps | 80%
3060 | sepe_half | No | No | No | x2_half | 53fps | 85%
3060 | sepe_half | No | No | No | x2_full | 30fps | 94%
3060 | sepe_half | No | No | No | x4_half | 49fps | 90%
3060 | sepe_half | No | No | No | x4_full | 45fps | 90%
3060 | sepe_half | No | No | x2_half | No | 64fps | 45%
3060 | sepe_half | No | No | x2_full | No | 63fps | 50%
3060 | sepe_half | No | No | x3_half | No | 64fps | 35%
3060 | sepe_half | No | No | x3_full | No | 64fps | 42%
3060 | sepe_half | No | No | x4_half | No | 64fps | 30%
3060 | sepe_half | No | No | x4_full | No | 64fps | 40%

DirectML问题: 
* A770: rife插帧全精度会出现奇怪结果, waifu2x 全精度会输出全绿色
* RX580 tha3 模型半精度会输出奇怪结果
* 3060 有时出现奇怪运行时占用上升，猜测驱动问题。