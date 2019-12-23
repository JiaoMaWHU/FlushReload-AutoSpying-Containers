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
sudo apt-get install ruby-dev
```

### Automatic spying tool
