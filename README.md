eZuce containers
================

```
            ------         ---------          ----------
   code -> |github|   <-- |travis-ci|  -->   | dockerhub |    
            ------         ---------          ---------- 
                                              ----------- 
                                       -->    |AWS for QA|
                                               -----------
                                               
```

Code commited on swarmcomm/docker branches (master, minimal and sipxconfig) will cause automatic build with travis-ci based on the  .travis.yml file which is self explanatory

After travis finishes building the docker images it will push them on dockerhub [![N|Dockerhub](https://hub.docker.com/u/ezuce/)


After building and publishing of docker images is finished, travis will deploy containers on an AWS EC2 machine for QA tests 
