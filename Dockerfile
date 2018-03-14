FROM fedora:27

MAINTAINER Christian Kleinhuis <trifox@users.noreply.github.com>

LABEL description Library rich Robot Framework in Docker Chrome Headless.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# install required modules
RUN dnf install -y\
	    #which-2.21* \
		chromedriver-63*\
		chromium-63*\
		python2-pip-9.0.1*\
	&& dnf clean all

# install required/wanted robot-libraries and needed python modules
RUN pip install \
	# Base Libraries\
	robotframework==3.0.2\
	requests==2.18.4\
	robotframework-requests==0.4.7\
	# Data Exchange\
	robotframework-jsonlibrary==0.2\
	robotframework-csvlibrary==0.0.2\
	robotframework-yamllibrary==0.2.8\
	robotframework-jsonschemalibrary==1.0\
	# Database\
	robotframework-mongodblibrary==0.3.4\
	robotframework-databaselibrary==1.0.1\
	# Services\
	robotframework-imaplibrary==0.3.0\
	robotframework-kafkalibrary==0.0.1\
	robotframework-advancedlogging==1.0.1\
	# Util\
	robotframework-difflibrary==0.1.0\
	robotframework-lint==0.9\
	robotframework-stringformat==0.1.7\
	robotframework-randomlibrary==0.0.2\
	robotframework-seleniumlibrary==3.1.1

# inactive due to size
#	robotframework-websocketclient==1.3.0\
#	robotframework-zookeeperlibrary==0.1.4\
#	robotframework-async==1.0.3\
#	robotframework-wiremock==0.0.8\
#	robotframework-sshlibrary==2.1.3\
#	robotframework-rabbitmq==1.0.1\

# env setup for running tests
# ENV SERVE_REPORTS 1 --- 1=start express on port:3000 to browse and restart tests 0=just execute tests
ENV ROBOT_PARAMS '--loglevel TRACE'
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_WIDTH 1920
ENV SCREEN_HEIGHT 1080

ENV LOG_LEVEL x
ENV BROWSER chrome


#-e --include tag *       Select test cases to run by tag. Similarly as name
#                          with --test, tag is case and space insensitive and it
#                          is possible to use patterns with `*` and `?` as
#                          wildcards. Tags and patterns can also be combined
#                          together with `AND`, `OR`, and `NOT` operators.
#                          Examples: --include foo --include bar*
ENV ROBOT_INCLUDE_TAG ''
#-e --exclude tag *       Select test cases not to run by tag. These tests are
#                          not run even if included with --include. Tags are
#                          matched using the rules explained with --include.
ENV ROBOT_EXCLUDE_TAG ''
#-c --critical tag *      Tests having given tag are considered critical. If no
#                          critical tags are set, all tags are critical. Tags
#                          can be given as a pattern like with --include.
ENV ROBOT_CRITICAL_TAG 'critical'
# -n --noncritical tag *   Tests with given tag are not critical even if they
#                          have a tag set with --critical. Tag can be a pattern.
ENV ROBOT_NONCRITICAL_TAG 'noncritical'
# -L --loglevel level      Threshold level for logging. Available levels: TRACE,
#                          DEBUG, INFO (default), WARN, NONE (no logging). Use
#                          syntax `LOGLEVEL:DEFAULT` to define the default
#                          visible log level in log files.
#                          Examples: --loglevel DEBUG
#                                    --loglevel DEBUG:INFO
ENV ROBOT_LOGLEVEL 'INFO'
# Remaining robot options inserted at the end of robot config, before test folder
ENV ROBOT_OPTIONS ''

#ADD drivers/geckodriver-v0.19.1-linux64.tar.gz /opt/robotframework/drivers/
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser

COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/
COPY bin/system-status.sh /opt/robotframework/bin/
#COPY bin/firefox-browser.sh /opt/robotframework/bin/

#RUN which firefox
# WIP but for now removed for the sake of smaller image, just headless chrome ...
# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original
RUN ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

#RUN mv /usr/bin/firefox /usr/bin/firefox-original
#RUN ln -sfv /opt/robotframework/bin/firefox-browser /usr/bin/firefox

 RUN rm -rf /var/cache/*
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH
EXPOSE 3000
CMD ["run-tests-in-virtual-screen.sh" ]
