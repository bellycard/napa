FROM belly/buildstep
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
# add ANYTHING that would be compiled during the build phase, like assets, here

RUN /build/builder
ADD . /app
CMD /start web
