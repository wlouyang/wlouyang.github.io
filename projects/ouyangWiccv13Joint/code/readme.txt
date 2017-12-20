This code is the training and testing code for the deep model in [a]. This code is based on the deeplearningtoolbox [c].

The entrance code for training on the Caltech Dataset is "./CNN/cnnexamples.m".
The entrance code for testing on the Caltech and ETH is "./CNN/Testing.m".

In order to run the code:
1.	Compile the "./CNN/dtAccS.cc" and "./CNN/dtAccS.cc" by running the "./CNN/compile.m". The compiled "dtAccS.mexw64" and "fconvn.mexw64" on Windows7 64bit version is also provided.
2.	Run cnnexamples.m or testing.m.

For Testing.m, you should ge 39.32% for Caltech and 45.32% for ETH.

Note: we use the HOG+CSS+SVM in [b] for pruning the large number of testing samples. The source code for HOG+CSS+SVM will be released soon.

[a] Wanli Ouyang, Xiaogang Wang, "Joint Deep Learning for Pedestrian Detection ", In Proc. IEEE ICCV 2013. 
[b] Xingyu Zeng, Wanli Ouyang, Xiaogang Wang, "Multi-Stage Contextual Deep Learning for Pedestrian Detection ", In Proc. IEEE ICCV 2013. 
[c] https://github.com/rasmusbergpalm/DeepLearnToolbox
