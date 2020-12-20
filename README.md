
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
a simulation of energy consumption of a federated learning system consist of one **central server** and a set of 𝒦 ≜ {1,2, ...,n-1, n} **local machines** (in Figure, each hospital are shown as a local machines)
![Federated Learning Workflow ](https://miro.medium.com/max/1004/1*TdAsPh83Di4YkozLUxYz6Q.png)
credit : https://rb.gy/bc4zmm

In general, the federated learning system would follow the 4 steps below.
1. **central server broadcast global weight to local machines**: The server broadcasts the global weight (Δ𝑤) to each local machines
2. **local machine updates local weights**: each local machine updates its local weight in a local iteration (ℕ) to minimize the loss function.
3. **local machines upload local weights to the central server**: The local machines upload their updated local weight Δ𝑤<sub>1</sub>, Δ𝑤<sub>2</sub>, . . , Δ𝑤<sub>n-1</sub>, Δ𝑤<sub>n</sub> to the server.
4. **central server aggregate local weight and updated global weights**: The server aggregates all the uploaded local weight from *n* local machines and updates the global weight (Δ𝑤) by averaging them
> This project set up has 1 central server and 3 local machines.
 
𝕄

## 0. Software Structure
| |Description |
|-|-|
 |[class](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/tree/main/class "class")<br>- cnn_model.m<br>- communication.m<br>- device.m<br>- server.m| <br>this project use CNN to minimize the loss function. If you want to use other algorithm, you can ignore this file. |
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
