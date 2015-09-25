# https://shopify.github.io/dashing/

FROM brimstone/ubuntu:14.04

MAINTAINER brimstone@the.narro.ws

# Install the packages we need, clean up after them and us
RUN package bundler ruby-dev build-essential vim nodejs zlib1g-dev \

 && gem install --no-ri --no-rdoc dashing execjs \
 && dashing new dashboard \
 && cd dashboard \

 && echo "" >> Gemfile \
 && echo "gem 'dashing-contrib', '~> 0.1.6'" >> Gemfile \
 && sed -i "1i\$: << File.expand_path('./lib', File.dirname(__FILE__))" config.ru\
 && sed -i "2irequire 'dashing-contrib'" config.ru \
 && sed -i "4iDashingContrib.configure" config.ru

RUN cd dashboard \
 && sed -i '7i#=require dashing-contrib/assets/widgets' assets/javascripts/application.coffee \
 && sed -i '4i//=require dashing-contrib/assets/widgets' assets/stylesheets/application.scss \
 && bundle

# Set our command
ENTRYPOINT ["/usr/local/bin/dashing"]

WORKDIR /dashboard

CMD ["start"]

VOLUME /dashboard

EXPOSE 3030
