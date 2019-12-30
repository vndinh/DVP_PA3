1. Structure of directories

PA#3_DinhVu
	|
	|--data
	|	|--flownetc
	|	|--flownets
	|
	|--FlowNetPytorch_1
	|--FlowNetPytorch_2
	|--FlyingChairs_release
	|	|--data
	|
	|--models
	|--source

2. Explaination
	- Two frames for the below experiments are extracted from 'Calendar_CIF30.yuv' and stored in 'data' folder
	- The outputs of FlowNetC are saved in 'data/flownetc'
	- The outputs of FlowNetS are saved in 'data/flownets'
	- For problem 1 and 2, use 'FlowNetPytorch_1' and 'FlowNetPytorch_2', respectively
	- The Flying Chairs dataset is stored in 'FlyingChairs_release/data'
	- All pretrained weights are stored in 'models' folder
	- All matlab files for evaluation are included in 'source' folder

3. How to run
	- Uncompress the 'FlyingChairs.zip' to FlyingChairs_release, organized like in the structure of Section 1
	3.1. Extract 2 frames
		- Open Matlab
		- Browse the working space of Matlab to the 'source' folder
		- In Command Window of Matlab, type: Extract_Frames
		- Go to 'data' folder to see 10th and 11th frame, named 'frame_0.png' and 'frame_1.png', respectively

	3.2. Problem 1a
		3.2.1. Get outputs of FlowNetS
			- Open Command Promt (Windows) or Terminal (Linux) in 'FlowNetTorch_1' folder
			- Type: python run_inference.py ../data/ ../models/flownets_EPE1.951.pth.tar --output=../data/flownets
			- Wait the process finish
			- The predicted optical flows are recorded in 'data/flownets/flow_map.mat' file
			- The RGB map of the optical flows are saved in 'data/flownets/frame_flow.png'

		3.2.2. Evaluation
			- Open Matlab
			- Browse the working space of Matlab to the 'source' folder
			- In Command Window of Matlab, type: exe1a_PA3
			- Wait the process finish

	3.3. Problem 1b
		3.3.1. Get outputs of FlowNetC
			- Open Command Promt (Windows) or Terminal (Linux) in 'FlowNetTorch_1' folder
			- Type: python run_inference.py ../data/ ../models/flownetc_EPE1.766.tar --output=../data/flownetc
			- Wait the process finish
			- The predicted optical flows are recorded in 'data/flownetc/flow_map.mat' file
			- The RGB map of the optical flows are saved in 'data/flownetc/frame_flow.png'

		3.3.2. Evaluation
			- Open Matlab
			- Browse the working space of Matlab to the 'source' folder
			- In Command Window of Matlab, type: exe1b_PA3
			- Wait the process finish

	3.4. Problem 2
		3.4.1. Training
			- Open Command Promt (Windows) or Terminal (Linux) in 'FlowNetTorch_2' folder
			- Type: python main.py ../FlyingChairs_release/data -j8 -b8 --epochs=100 --lr=0.0001 -a flownets
			- Wait the process finish
			+ My best model is stored in 'FlowNetPytorch_2/flying_chairs/11-21-15h23' folder

		3.4.2. Evaluation
			- Open Command Promt (Windows) or Terminal (Linux) in 'FlowNetTorch_2' folder
			- Type: python run_inference.py ../data ./flying_chairs/11-21-15h23/flownets,adam,100epochs,epochSize1000,b8,lr0.0001/model_best.pth.tar --output=../data/new_flownets
			- Wait the process finish
			
			- Open Matlab
			- Browse the working space of Matlab to the 'source' folder
			- In Command Window of Matlab, type: exe2_PA3
			- Wait the process finish

4. Read 'PA3_Report_DinhVu_20184187.pdf' for more details

