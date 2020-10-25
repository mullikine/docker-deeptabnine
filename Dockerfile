FROM silex/emacs:27.0-alpine

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories
RUN apk update
RUN apk add git
# RUN apk add xsel --no-cache
RUN apk add xclip --no-cache

# RUN apt-get update
# RUN apt-get install -y \
#   git \
#   emacs-nox \
#   elpa-magit \
#   locales

# RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV EMACS_BRANCH="master"
ENV EMACS_VERSION="master"
ENV TERM=screen-256color

COPY startup.el /startup.el
COPY theme.el /theme.el
COPY entry.sh /entry.sh
COPY my-shackle.el /my-shackle.el
COPY .emacs /root/.emacs
COPY .bashrc /root/.bashrc

RUN emacs --batch -l /startup.el -l /theme.el
RUN rm /startup.el
RUN mkdir /.ssh

# CMD eval `resize` && emacs --no-window-system --eval '(progn (magit-status) (delete-other-windows))'
CMD /entry.sh