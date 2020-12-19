
# On Simulating Energy Consumption of Federated Learning Systems 

This repository aim to provide **a simulation of energy consumption of a federated learning system based on the non-orthogonal multiple access (NOMA) transmission protocols**, proposed by Mo et. al. Energy consumption is computed during training along with energy consumed by communications between local machines and the server.

# How to run software 
1. Extract file .gz in folder "dataset" to binary file
2. Access to main.m and Run software in the MATLAB software
3. Click "Run" button in under "Editor" tab in menu bar
![matlab_toolbar](https://raw.githubusercontent.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/main/document/toolbar.png)
4. Adjust a number of local iteration (N) and global iteration (M) on line 3 and 4 in "main.m" to simulate energy consumption. The output will show in "Command window" or in graph.
&nbsp;&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/main/document/config_m_n.PNG" width="60%"/>

# Project Description
a simulation of energy consumption of a federated learning system consist of one central server and a set 𝒦 ≜ {1,2, ... , 𝐾} of local machines
![Federated Learning Diagram ](https://miro.medium.com/max/1004/1*TdAsPh83Di4YkozLUxYz6Q.png)
## 0. Software Structure
| |Description |
|-|-|
 |[class](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/tree/main/class "class")<br>- cnn_model.m<br>- communication.m<br>- device.m<br>- server.m| 00 |
|[dataset](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#dataset)	| 00 |
|aggregate_weight.m							||
|build_data_to_signal.m			||
|build_signal_to_data.m			||
|cnn_train.m										    ||
|comm_to_server.m									||
|decode_at_server.m							||
|display_output.m									||
|energy_at_loc.m									 ||
|energy_upload.m									 ||
|experiment.m										   ||
|flop.m												       ||
|main.m												       ||
|plot_signal.m										  ||
|time_and_energy_upload.m ||
|time_at_loc.m									   ||
|total_time_noma.m								||

## 1. Datasets <a name="dataset">
Our considered datasets, [MNIST](http://yann.lecun.com/exdb/mnist/) are located in folder “dataset”. If you want to use another dataset you can place it in this path and then change a file configuration in the file “[class/device.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/device.m)” (line 42-46) and “[class/server.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/server.m)” (line 18-21)

## 2. Experiment Setting


# Reference
 - [Energy-Efficient Federated Edge Learning with Joint Communication and Computation Design](https://arxiv.org/abs/2003.00199) by Mo et. al.
## 2. Experiment Setting


# Reference
 - [Energy-Efficient Federated Edge Learning with Joint Communication and Computation Design](https://arxiv.org/abs/2003.00199) by Mo et. al.
