# FlushReload-AutoSpying-Containers

This repository contains the source code of my class project: **I Know What You are Browsing:
A Side Channel Attack based on Flush and Reload**. This project proposes an automatic spying tool. Using this tool, the attack can know which web page the victim is visiting. Besides, this project also implements the attack in containers and discuss how to implement the attack in virtual environments.

This project is developed based on the code provided by [Side-Channel Attacks on Everyday Applications](https://github.com/defuse/flush-reload-attacks). Specifically, the bash script `auto-spying.sh` runs the automatic spying tool and is based two new files: `AttackRecorderAuto.rb` and `AttackRecoveryAuto.rb` in path `flush-reload/myversion/ruby`. To do this attack between containers, you should build a base image using the `Dockerfile`. Detailed instructions are in the next section.

# Running instructions
### Setup
Please try this attack in a standalone Linux machine, because Flush and Reload attack will fail in virtual machines or cloud instances. I discussed the reasons in my report and I used Ubuntu 18.0.4 in my experiment.

First, clone this repository.
```
$ cd ~
$ git clone git@github.com:JiaoMaWHU/FlushReload-AutoSpying-Containers.git
```
Follow the `Getting Started Guide` in [Side-Channel Attacks on Everyday Applications](https://github.com/defuse/flush-reload-attacks) and finish all the steps from `Installing the Dependencies` to the end. Note the repository name is different. 

When installing the dependencies, I would recommend to also install `ruby-dev` to avoid some dependencies problems.
```
$ sudo apt-get install ruby-dev
```

### Automatic spying tool
Create the folder for spying.
```
$ mkdir ~/attack_spying
```
I'm assuming you have finished 5.1 training in `Getting Started Guide` and the output directory is ~/attack_training/demo1. Then, we can start the spying tool.
```
$ ./auto-spying.sh
```
The tool will take every 5s as a window and do separate attack for this window. The bash script mainly contains instructions of 5.2, 5.4 in `Getting Started Guide`. You can simply change the configuration in the script like the length of the window or output directory.

Then, you can run as a new user in terminal and start to visit the web using the same links binary file.
```
$ ~/FlushReload-AutoSpying-Containers/experiments/links/binaries/links-demo http://en.wikipedia.org/wiki/Breaking_Bad
```
During your visiting, the attack tool is supposed to output some detected results with a confidence value.

### Flush and Reload in containers
To achieve flush and reload between two containers, we need to make sure they run the same binary file. To do this, you can use the provided `Dockerfile` to build the base image.

Copy the `Dockerfile` to the parent folder of our repository. In our example, it will be the 
```
$ cp ~/FlushReload-AutoSpying-Containers/Dockerfile ~/Dockerfile
```
Then, you can use Docker commands to build the base image. Please make sure you have the links source code file in the same path. If you have some troubles when building, take a look at the `Dockerfile` and you may probably figure it out. It just copies the source code to the docker image and start the compiling.

After the building the base image, you can use Docker commands to initialize two containers. Then, you can use tty to get inside of each container and run the attack as we do above.

If you are wondering why two containers initialized from the base image will run the same binary file, you can take a look at my report.