install:
	python3 -m venv venv
	. venv/bin/activate
	pip install --upgrade pip &&\
		pip install -r requirements.txt
lint:
	pylint --disable=R,C hello.py

test:
	python3 -m pytest -vv --cov=hello test_hello.py
