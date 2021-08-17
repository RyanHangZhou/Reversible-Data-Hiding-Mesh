# Reversible Data Hiding in Encrypted Three-Dimensional Mesh Models
Created by Ruiqi Jiang, [Hang Zhou](http://home.ustc.edu.cn/~zh2991/), [Weiming Zhang](http://staff.ustc.edu.cn/~zhangwm/index.html), [Nenghai Yu](http://staff.ustc.edu.cn/~ynh/).

Introduction
--
This work is published on Transactions on Multimedia (TMM), 2018. 

We propose a RDH technique in encrypted 3D meshes. The proposed method maps decimals of the vertex coordinates into integers first, so that the bit-stream encryption technique can be executed. With a data-hiding key, several LSBs are operated to embed data. By using the encryption key, a receiver can roughly reconstruct the content of the mesh. According to the data-hiding key, with the aid of spatial correlation in natural mesh models, the embedded data can be successfully extracted and the original mesh can be perfectly recovered.


Usage
--


    Download "toolbox_graph", a public toolbox for 3D mesh processing;
    Put source 3D meshes in the "data/source" directory;
    Start from main.m.


Citation
--
If you find our work useful in your research, please consider citing:

    @article{jiang2018reversible,
      title={Reversible Data Hiding in Encrypted Three-Dimensional Mesh Models},
      author={Jiang, Ruiqi and Zhou, Hang and Zhang, Weiming and Yu, Nenghai},
      journal={IEEE Transactions on Multimedia},
      volume={20},
      number={1},
      pages={55--67},
      year={2018},
      publisher={IEEE}
    }
    
    
License
--
