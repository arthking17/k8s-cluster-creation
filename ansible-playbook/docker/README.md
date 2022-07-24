# Docker role

## Execute docker without sudo

- [ ] To create the docker group and add your user

```shell
sudo groupadd docker #Create the docker group
sudo usermod -aG docker $USER #Add your user to the docker group
newgrp docker #Log out and log back in so that your group membership is re-evaluated
docker ps #Verify that you can run docker commands without sudo
```
