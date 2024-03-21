# Build the Docker image
docker build -t armyguy255a/cloud-tools .

docker save -o D:\Containers\Linux\armyguy255a--cloud-tools.tar.gz armyguy255a/cloud-tools

# Run the Docker container with the code-server
docker run -it --name vscode-server -v vscode-server:/root --rm -p 8080:8080 armyguy255a/cloud-tools code-server --auth none --bind-addr 0.0.0.0:8080

# Run the container in vSphere Integrated Containers VIC / VCH
docker -H vch3.domain.local:2376 --tls volume create --name vscode-server --opt Capacity=20GB
docker -H vch3.domain.local:2376 `
--tls run `
-it `
--cpuset-cpus '4' `
--memory 16GB `
--net Default `
-p 80:8080 `
--ip 22.119.4.201 `
--name vscode-server `
-v 'vscode-server:/root' `
vic3.tsi.mil/default-project/armyguy255a/cloud-tools:latest code-server --auth none --bind-addr 0.0.0.0:8080

# Other notes
It may be necessary to copy the ca.crt for the registry to the VIC host. Here's a command that may help out with this.

```bash
nano /usr/local/share/ca-certificates/ca.crt
update-ca-certificates
docker login vic3.tsi.mil
docker -H vch3.tsi.mil:2376 --tls container ls
```