FROM fedora:27

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
MAINTAINER Christian Kleinhuis <ck@froso.de>
LABEL description Robot Framework in Docker.

VOLUME $ROBOTFRAMEWORK_PATH/reports
VOLUME $ROBOTFRAMEWORK_PATH/tests

# env setup for running tests
ENV SERVE_REPORTS 1 # 1=start express on port:3000 to browse and restart tests 0=just execute tests
ENV ROBOTFRAMEWORK_PATH /opt/robotframework
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

ADD drivers/geckodriver-v0.19.1-linux64.tar.gz $ROBOTFRAMEWORK_PATH/drivers/

COPY bin/chromedriver.sh $ROBOTFRAMEWORK_PATH/bin/chromedriver
COPY bin/chromium-browser.sh $ROBOTFRAMEWORK_PATH/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh $ROBOTFRAMEWORK_PATH/bin/
COPY bin/serve-and-execute-reports.js $ROBOTFRAMEWORK_PATH/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv $ROBOTFRAMEWORK_PATH/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

ENV PATH=$ROBOTFRAMEWORK_PATH/bin:$ROBOTFRAMEWORK_PATH/drivers:$PATH
EXPOSE 3000
#CMD ["run-tests-in-virtual-screen.sh"]
CMD ["serve-and-execute-reports.js"]
