FROM artifactory.service.canary.sh:5000/canary-docker/terragrunt:0.9.2-0.9.6

ADD . /src
WORKDIR /src
