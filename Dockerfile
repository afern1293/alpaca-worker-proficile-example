FROM python:3.6

RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
  cd ta-lib/ && \
  ./configure --prefix=/usr && \
  make && \
  make install
RUN rm -R ta-lib ta-lib-0.4.0-src.tar.gz

RUN pip install --upgrade pip
RUN pip install pipenv

ADD Pipfile Pipfile.lock /

RUN pipenv install --system

RUN pip uninstall -yqq bottleneck
RUN pip uninstall -yqq numpy
RUN pip install numpy
RUN pip install bottleneck

ADD paper.py /usr/local/lib/python3.6/site-packages/pylivetrader/backend/

FROM sturlese/trading_base:1.0

ADD reversion.py /work/reversion.py

WORKDIR /work

CMD ["pylivetrader", "run", "-f", "/work/reversion.py","--data-frequency","minute","-b","paper"]
