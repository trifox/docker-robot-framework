FROM fedora:27

MAINTAINER Christian Kleinhuis <trifox@users.noreply.github.com>
MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>

LABEL description Library Rich Robot Framework in Docker Firefox&Chrome.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# env setup for running tests
# ENV SERVE_REPORTS 1 --- 1=start express on port:3000 to browse and restart tests 0=just execute tests
ENV ROBOT_PARAMS '--loglevel TRACE'
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_WIDTH 1920
ENV SCREEN_HEIGHT 1080
RUN echo 'log level v vv vv'
ENV LOG_LEVEL x

# ENV NODE_PATH = /lib/node_modules  # somehow fedora does not set node path, so provide it


# install required modules
RUN dnf upgrade -y\
	&& dnf install -y\
	    which-2.21-4.fc27 \
		chromedriver-63.0.3239.108-1.fc27\
		chromium-63.0.3239.108-1.fc27\
		firefox-58.0.2-1.fc27\
		python2-pip-9.0.1-14.fc27\
		xorg-x11-server-Xvfb-1.19.6-5.fc27\
	&& dnf clean all

# install required/wanted robot-libraries and needed python modules
RUN pip install robotframework==3.0.2\
	requests==2.18.4\
	robotframework-requests==0.4.7\
	robotframework-advancedlogging==1.0.1\
	robotframework-imaplibrary==0.3.0\
	robotframework-difflibrary==0.1.0\
	robotframework-async==1.0.3\
	robotframework-lint==0.9\
	robotframework-mongodblibrary==0.3.4\
	robotframework-databaselibrary==1.0.1\
	robotframework-kafkalibrary==0.0.1\
	robotframework-jsonlibrary==0.2\
	robotframework-wiremock==0.0.8\
	robotframework-yamllibrary ==0.2.8\
	robotframework-sshlibrary ==2.1.3\
	robotframework-stringformat ==0.1.7\
	robotframework-zookeeperlibrary ==0.1.4\
	robotframework-rabbitmq ==1.0.1\
	robotframework-assertions ==0.0.1\
	robotframework-csvlibrary ==0.0.2\
	robotframework-randomlibrary ==0.0.2\
	robotframework-websocketclient ==1.3.0\
	robotframework-jsonschemalibrary==1.0\
	robotframework-seleniumlibrary==3.1.1

ADD drivers/geckodriver-v0.19.1-linux64.tar.gz /opt/robotframework/drivers/

COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/
COPY bin/system-status.sh /opt/robotframework/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH
EXPOSE 3000
CMD ["run-tests-in-virtual-screen.sh" ]
