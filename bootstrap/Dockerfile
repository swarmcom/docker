FROM python:3.4-alpine
WORKDIR /bootstrap
COPY bootstrap.py /bootstrap
COPY requirements.txt /bootstrap
RUN pip install -r requirements.txt
CMD ["python", "bootstrap.py"]

