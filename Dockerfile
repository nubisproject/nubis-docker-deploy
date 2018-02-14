# Docker image containing all dependencies for running terraform in Nubis

FROM alpine:3.6
MAINTAINER Jason Crowe <jcrowe@mozilla.com>

# Do not add a 'v' as pert of the version string (ie: v1.1.3)
#+ This causes issues with extraction due to GitHub's methodology
#+ Where necesary the 'v' is specified in code below
ENV AwCliVersion=1.10.38 \
    TerraformVersion=0.10.8 \
    UnicredsVersion=1.5.1 \
    Toml2JSONVersion=0.1.0
WORKDIR /nubis

# Install container dependencies
#+ Cleanup apk cache files
RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq=1.5-r3 \
    py-pip \
    rsync \
    unzip \
    && rm -f /var/cache/apk/APKINDEX.* \
    && pip install awscli==${AwCliVersion} \
    && pip install -v toml2json==${Toml2JSONVersion} \
    && mkdir -p /nubis/bin /nubis/work

# Install Terraform & Unicreds
RUN ["/bin/bash", "-c", "set -o pipefail \
    && curl -L -o terraform_${TerraformVersion}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TerraformVersion}/terraform_${TerraformVersion}_linux_amd64.zip \
    && unzip terraform_${TerraformVersion}_linux_amd64.zip -d /nubis/bin \
    && rm terraform_${TerraformVersion}_linux_amd64.zip \
    && curl -L https://github.com/Versent/unicreds/releases/download/${UnicredsVersion}/unicreds_${UnicredsVersion}_linux_amd64.tar.gz \
    | tar -C /nubis/bin -xzf -" ]

# Copy over the nubis-deploy script
COPY [ "nubis-deploy", "/nubis/bin/" ]

# Copy over the account-deploy script
COPY [ "account-deploy", "/nubis/bin/" ]

ENV PATH /nubis/bin:$PATH
ENTRYPOINT [ "/nubis/bin/nubis-deploy" ]
CMD [ "help" ]
