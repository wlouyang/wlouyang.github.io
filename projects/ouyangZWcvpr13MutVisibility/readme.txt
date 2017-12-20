This code is the testing code for the deep model in [a]. This code is based on the deeplearningtoolbox [c].

The entrance code is "main.m".

In order to run the code:
1.  unzip annotations.zip & res.zip in eval/data-ETH
2.  unzip annotations.zip & res.zip in eval/data-PETS
3.  unzip annotations.zip & res.zip & toolbox.zip in eval/data-USA
4.  run main.m in matlab

Note: 
In main.m, line 21, you can select which dataset to run

%0: caltech train; 1: ETHZ; 4:caltech test; 5: PETS
DatasetTable = [5]; 


[a] W. Ouyang, X. Zeng and X. Wang. Learning Mutual Visibility Relationship for Pedestrian Detection with a Deep Model. 