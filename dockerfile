# base image Crypto 8-bit
FROM ubuntu:22.04


# Set environment to noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    software-properties-common \
    git \
    nano \
    sudo \
    dbus libdbus-1-3 dbus-x11 \
    python3.9 \
    python3-pip \
    alsa-utils \
    wget && \
    apt-get clean

# Clone the repository and install FEBio Studio
# RUN git clone https://github.com/mdeliso97/Docker_FEBio.git && \
#     chmod +x Docker_FEBio/FEBioStudio_2-7/FEBioStudio_linux-x64_2-7.run && \
#     ./FEBioStudio_linux-x64_2-7.run --mode unattended --prefix /FEBioStudio

COPY home/mdeliso97/Downloads/FEBioStudio_2-7/ .

# Add FEBio Studio to the PATH
ENV PATH="/FEBioStudio/bin/FEBioStudio:${PATH}"

# Install Intel OpenAPI base toolkit
RUN wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/e6ff8e9c-ee28-47fb-abd7-5c524c983e1c/l_BaseKit_p_2024.2.1.100_offline.sh && \
    sh ./l_BaseKit_p_2024.2.1.100_offline.sh -a --silent --cli --eula accept && \
    apt update && \
    apt -y install cmake pkg-config build-essential && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh --silent silent.cfg
    #rm -rf /l_openvino_toolkit_p_2022.1.110

# Setup the working directory
RUN mkdir /cbuild

# Clean up
RUN apt-get clean && \
    rm -rf /Docker_FEBio

# Launch Crypto 8-bit
CMD ["python3", "cryptology.py"]
