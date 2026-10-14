.PHONY: help setup test audit eda baselines clean docker-build

PYTHON ?= python

help:
	@echo "MLOps Pipeline CLI Commands:"
	@echo "  make setup      - Install pinned dependencies"
	@echo "  make test       - Run test suite (pytest)"
	@echo "  make audit      - Run comprehensive 42-check validation audit"
	@echo "  make eda        - Run exploratory data analysis and generate profile plots"
	@echo "  make baselines  - Run baseline simulation controllers"
	@echo "  make scaffold   - Run research scaffolding (assets, monitor, registry)"
	@echo "  make docker-build - Build reproducible Docker container"

setup:
	pip install --upgrade pip
	pip install "numpy==1.26.4" "scikit-learn<=1.2.2" "gymnasium==0.28.1" "stable-baselines3==2.0.0" "simplejson" "pyyaml" "matplotlib" "seaborn" "lz4" "pytest" "scipy"
	pip install --no-deps "citylearn==3.0.2"

test:
	$(PYTHON) -m pytest tests/ -v

audit:
	$(PYTHON) scripts/validate_phase1.py

eda:
	$(PYTHON) -m src.rle.eda

baselines:
	$(PYTHON) -m src.rle.run_baselines

scaffold:
	$(PYTHON) -m src.assets.manager
	$(PYTHON) -m src.monitor.benchmark
	$(PYTHON) -m src.registry.demo_gate

docker-build:
	docker build -t energy-controller:phase1 .
