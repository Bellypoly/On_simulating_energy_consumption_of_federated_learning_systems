
# On Simulating Energy Consumption of Federated Learning Systems 

This repository aim to provide **a simulation of energy consumption of a federated learning system based on the non-orthogonal multiple access (NOMA) transmission protocols**, proposed by Mo et. al. Energy consumption is computed during training along with energy consumed by communications between local machines and the server.

# How to run software 
1. Extract file .gz in folder "dataset" to binary file
2. Access to main.m and Run software in the MATLAB software
3. Install additional toolboxes (`Deep Learning Toolbox` and `Communications Toolbox`) [ⓘ](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html)
4. Click "Run" button in under "Editor" tab in menu bar
![matlab_toolbar](https://raw.githubusercontent.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/main/document/toolbar.png)
5. Adjust a number of local iteration (N) and global iteration (M) on line 3 and 4 in "main.m" to simulate energy consumption. The output will show in "Command window" or in graph.<br>
&nbsp;<img src="https://raw.githubusercontent.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/main/document/config_m_n.PNG" width="60%"/>

# Project Description
A simulation of energy consumption of a federated learning system consists of one **central server** and a set of 𝒦 ≜ {1,2, ...,n-1, n} **local machines** (in Figure, each hospital are shown as a local machine)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img alt="Federated Learning Workflow " src="https://miro.medium.com/max/1004/1*TdAsPh83Di4YkozLUxYz6Q.png" width="60%"/><br>
credit : https://rb.gy/bc4zmm

In general, the federated learning system would follow the 4 steps below.
1. ***central server broadcast global weight to local machines***: The server broadcasts the global weight (Δ𝑤) to each local machines
2. ***local machine updates local weights*** each local machine updates its local weight in a local iteration (ℕ) to minimize the loss function.
3. ***local machines upload local weights to the central server*** The local machines upload their updated local weight Δ𝑤<sub>1</sub>, Δ𝑤<sub>2</sub>, . . , Δ𝑤<sub>n-1</sub>, Δ𝑤<sub>n</sub> to the server.
4. ***central server aggregate local weight and updated global weights*** The server aggregates all the uploaded local weight from *n* local machines and updates the global weight (Δ𝑤) by averaging them

From step 1 to 4, the process would repeat in a global iteration (𝕄)
> This project set up has **1 central server and 3 local machines**. The configuration in a central server and each local machines are in folder "**class**"

## 0. Software Structure
The structure of this project is as shown below the table.
| |Description |
|-|-|
|[class/...](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/tree/main/class "class")||
|&nbsp;&nbsp;&nbsp;&nbsp;- [cnn_model.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/cnn_model.m)|`cnn_model()` : this project uses CNN to minimize the loss function. If you want to use another algorithm, you can ignore this file.|
|&nbsp;&nbsp;&nbsp;&nbsp;- [communication.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/communication.m)|`communication()` : This file use to config signal transmission parameters i.e. noise power at the server, the distance between each local machine and server, etc. in **NOMA transmission protocol**.|
|&nbsp;&nbsp;&nbsp;&nbsp;- [device.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/device.m)|`device()` : Configuration in each local machine parameter i.e. train and test dataset, transmission power, CPU cycle, achievable rate, etc.|
|&nbsp;&nbsp;&nbsp;&nbsp;- [server.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/server.m)|`server()` : Configuration in central server parameter i.e. train and test dataset, etc.|
|[dataset/..](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#dataset)	| The train and test dataset would locate in this folder. |
|[main.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/main.m)												       | Use this file to run this project which would call the related function to follow these steps: <br>1. Train model at the server to provide an initial global weight to each local machine (call [`cnn_train()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#cnn_train))<br>2. Each local machine receive a global weight(Δ𝑤) then call [`cnn_train()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#cnn_train) to minimize the loss function, then call [`time_at_loc()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#time_at_loc) and [`energy_at_loc()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#energy_at_loc) to calculate time and energy consumption in computational part at each local machine<be>3. The updated weight from each local machine after minimizing the loss function would be converted to a signal by call [`build_data_to_signal()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#build_data_to_signal)<br>4. The signal from each local machine would be sent to the central server via NOMA protocol by call [`comm_to_server()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#comm_to_server)<br>5. Central server would receive a signal which considers noise from communication (AWGN). Updated weights in the signal form are decoded to data by calling [`decode_at_server()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#decode_at_server) and [`build_signal_to_data()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#build_signal_to_data)<br>6. Time and energy consumption from communication would be calculated by calling [`time_and_energy_upload()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#time_and_energy_upload)<br>7. Central server would use [`aggregate_weight()`](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems#aggregate_weight) to aggregate and calculate new global weight from the updated weight at each local machine |
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/aggregate_weight.m" name="aggregate_weight">aggregate_weight.m</a>							|This file contains aggregate weight function<br>*input* : a set of local machince<br>*output* : a global weight (Δ𝑤)|
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/build_data_to_signal.m" name="build_data_to_signal">build_data_to_signal.m</a>			||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/build_signal_to_data.m" name="build_signal_to_data">build_signal_to_data.m</a>			||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/cnn_train.m" name="cnn_train">cnn_train.m</a>										    ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/comm_to_server.m" name="comm_to_server">comm_to_server.m</a>							||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/decode_at_server.m" name="decode_at_server">decode_at_server.m</a>							||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/display_output.m" name="display_output">display_output.m</a>								||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/energy_at_loc.m" name="energy_at_loc">energy_at_loc.m</a>									 ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/energy_upload.m" name="energy_upload">energy_upload.m</a>									 ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/experiment.m" name="experiment">experiment.m</a>										   ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/flop.m" name="flop">flop.m</a>												       ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/plot_signal.m" name="plot_signal">plot_signal.m</a>										  ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/time_and_energy_upload.m" name="time_and_energy_upload">time_and_energy_upload.m</a> ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/time_at_loc.m" name="time_at_loc">time_at_loc.m</a>									   ||
|<a href="https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/total_time_noma.m" name="total_time_noma">total_time_noma.m</a>								||

## 1. Datasets <a name="dataset">
Our considered datasets, [MNIST](http://yann.lecun.com/exdb/mnist/) are located in folder “dataset”. If you want to use another dataset you can place it in this path and then change a file configuration in the file “[class/device.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/device.m)” (line 42-46) and “[class/server.m](https://github.com/Bellypoly/On_simulating_energy_consumption_of_federated_learning_systems/blob/main/class/server.m)” (line 18-21)

## 2. Experiment Setting


# Reference
 - [Energy-Efficient Federated Edge Learning with Joint Communication and Computation Design](https://arxiv.org/abs/2003.00199) by Mo et. al.
