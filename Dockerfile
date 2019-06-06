# Grading base tag
ARG BASE_TAG=latest

# "Inheriting" from another container called `grading-base`
FROM apluslms/grading-base:$BASE_TAG

# Copy the folder `mathcheck` in current working directory
# to `/user/local/mathcheck` inside the container
COPY mathcheck/ /usr/local/bin/mathcheck

# Change working directory
# RUN cd /usr/local/bin/mathcheck

# Args for compiling MathCheck
ARG MATHCHECK_SOURCE=/usr/local/bin/mathcheck/mathcheck.cc
ARG MATHCHECK_BIN=/usr/local/bin/mathcheck.out

<<<<<<< HEAD
# Install g++ for compiling MathCheck
=======
# Install g++ dor compiling MathCheck
>>>>>>> 766adf4daa38f36755600f0665febfc65f05a026
RUN  apt update \
  && apt install -y g++ \
  && g++ -static \
    -o $MATHCHECK_BIN $MATHCHECK_SOURCE


# Run MathCheck
ENTRYPOINT [ "mathcheck.out" ]