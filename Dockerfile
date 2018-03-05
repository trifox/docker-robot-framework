FROM fedora:27

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
MAINTAINER Christian Kleinhuis <ck@froso.de>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# env setup for running tests
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920


# install required modules
RUN dnf upgrade -y\
	&& dnf install -y\
	    which \
		chromedriver-63.0.*\
		chromium-63.0.*\
		firefox-58.0*\
		python2-pip-9.0.1*\
		xorg-x11-server-Xvfb-1.19.*\
	&& dnf clean all

# additionally install node with express module for simple web hosting
RUN dnf upgrade -y\
	&& dnf install -y\
	    nodejs \
	    nodejs-express \
	&& dnf clean all

# install required/wanted robot-libraries and needed python modules
RUN pip install robotframework==3.0.2\
	requests==2.18.4\
	robotframework-requests==0.4.7\
	robotframework-imaplibrary==0.1.4\
	robotframework-difflibrary==0.1.0\
	robotframework-lint\
	robotframework-seleniumlibrary==3.0.1

ADD drivers/geckodriver-v0.19.1-linux64.tar.gz /opt/robotframework/drivers/

COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

#CMD ["run-tests-in-virtual-screen.sh"]
CMD ["serve-and-execute-reports.js"]
