# Debian_Module_Builder
A tool for automatically building missing mainline modules for the Debian kernel

In theory if you require a kernel module that isn't provided by your distrobution's kernel package you should build your own kernel package. In practice this can be kind of a pain when compared to a simple "apt-get upgrade linux-image".

This script aims to make the process as painless as possible by automatically determining if the modules you specify need to be built for any of the kernels installed on the system and if so builds and installs them as efficiently as possible. 

The script extracts only the needed parts of the kernel source in an effort mimimize the space required, this results in a usage of about 100-200MB per kernel. This is still better than >1GB of decompressing the whole kernel.

## Usage
1. copy/download the script to your device running Debian or a Debian derivative.
2. Modify the beggining of the script to include the name of the required module and the line from the kernel config needed to build it (the script includes examples).
3. Run the script as root.

The script only builds modules if they are missing so it's safe to run multiple times or even run automatically at boot if you want.

Feel free to modify this to suit your needs. I'm open to suggestions for fixes/enhancements, but also do not plan to impliment anything more complicated than automating a proper build workflow for a custome kernel package.
