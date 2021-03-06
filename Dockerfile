#Radware docker image
FROM ubuntu:20.04

MAINTAINER Ross Allen (rossallen1996@gmail.com) 

#Installing radware to OS
ADD rw05.3.tgz /home/

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN apt update && \
    apt install -y build-essential && \
    apt install -y libreadline-dev && \
    apt install -y libgtk2.0-dev && \
    apt install -y libmotif-dev
    
# Fixing font installs 
RUN apt install -y xfonts-base && \
    apt install -y xfonts-75dpi && \
    apt install -y xfonts-100dpi && \
    apt install -y xfonts-utils && \
    apt install -y gsfonts-x11 && \
    cd usr/share/fonts/X11/100dpi #&& \
    #xset fp+ /usr/share/fonts/100dpi && \
    #xset fp+ /usr/share/fonts/X11/100dpi
# Changing working directory to source folder 
WORKDIR /home/rw05/src 

# Comment out the lines requiring -lXp
RUN sed -i "s|-lXp|#-lXp|g" /home/rw05/src/Makefile.linux
RUN sed -i "s|radfordd|root|g" /home/rw05/src/Makefile.linux

WORKDIR /home/rw05/src 
# Make all with the linux make file
RUN cp Makefile.linux Makefile && \
    make all && \
#    make gtk && \
   make install
    
   
ENV RADWARE_HOME="$HOME/rw_current"
ENV RADWARE_FONT_LOC=/home/rw_05/font
ENV RADWARE_ICC_LOC=/home/rw_05/icc
ENV RADWARE_GFONLINE_LOC=/home/rw_05/doc
ENV RADWARE_CURSOR_BELL=y
ENV RADWARE_OVERWRITE_FILE=ask
ENV RADWARE_AWAIT_RETURN=n
ENV RADWARE_XMG_SIZE=600x500

# Adding radware to path 
ENV PATH="/home/rw_05/bin:${PATH}"
ENV PATH="/home/rw05/src:${PATH}"
    


#SHELL ["/bin/bash", "-c", "source /usr/local/bin/virtualenvwrapper.sh"]    

#RUN make clean && \
#    make very-clean#

######## INSTALLING SPEC-CONV #############################
#ADD spec_conv.c /opt/
#WORKDIR /opt/
#RUN gcc spec_conv.c -Wall -pedantic -o spec_conv -lm -O2
#ENV PATH="/opt"

#ENV PATH="/home/rw05:${PATH}"
######### TEST FILES #######################################
# Creating test environment (will be removed in full deployment) 
RUN mkdir /home/test
ADD test.spe /home/test/
WORKDIR "/home/test"
