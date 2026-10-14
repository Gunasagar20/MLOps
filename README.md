# AI-Based Energy Conservation Awareness System
## Explainable RL Controller for Adaptive Energy Assets in Buildings

[![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/)
[![CI/CD Pipeline](https://github.com/Dilraj07/MLPOS/actions/workflows/ci.yml/badge.svg)](https://github.com/Dilraj07/MLPOS/actions)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](Dockerfile)
[![CityLearn 3.0.2](https://img.shields.io/badge/citylearn-3.0.2-green.svg)](https://github.com/citylearn-project/CityLearn)
[![Stable-Baselines3 2.0.0](https://img.shields.io/badge/stable--baselines3-2.0.0-orange.svg)](https://stable-baselines3.readthedocs.io/)
[![DVC Versioned](https://img.shields.io/badge/data-DVC--tracked-9cf.svg)](https://dvc.org/)
[![MLflow Tracked](https://img.shields.io/badge/experiments-MLflow-0194E2.svg)](https://mlflow.org/)

**Phase 1 Deliverable: Development, Baselines, and Reproducibility**  
*Production MLOps architecture featuring GitHub Actions Cloud CI/CD, Docker containerization, DVC data versioning, MLflow Model Registry, and Kaggle Cloud execution.*

---

## 1. Executive Summary & Findings

This project develops an explainable reinforcement learning controller to coordinate flexible building energy assets (HVAC, thermal energy storage, electrical batteries, and EV chargers) to minimize electricity costs, reduce grid carbon emissions, and shave peak demand without sacrificing occupant comfort.

**Research question:** Can an asset-conditioned RL controller transfer learned energy-management behavior to a previously unseen asset family, and can an MLOps pipeline detect when the transfer or its explanations fail before KPI harm occurs?

### Key Phase 1 Architectural Findings
1. **Scenario Unification (HVAC vs. EV):** No single CityLearn dataset bundles HVAC and EV charging together. Phase 1 evaluates two complementary scenarios under a unified interface:
   - **S1 (HVAC Scenario):** `citylearn_challenge_2023_phase_1` (3 buildings, 720 hours) and `2020_climate_zone_1-4` (9 buildings each, 8,760 hours multi-climate tests) featuring heat pump cooling devices, DHW storage tanks, and battery storage.
   - **S2 (EV Scenario):** `citylearn_challenge_2022_phase_all_plus_evs` (17 buildings, 8,760 hours) featuring stationary batteries, solar PV, EV chargers, and deferrable appliances.
2. **Three Levels of Generalization:** The evaluation cleanly separates L1 (within-family: unseen configs of known assets), L2 (cross-family zero-shot: held-out asset family), and L3 (few-shot adaptation: ≤500 steps on held-out family).
3. **Specialist vs. Generalist Comparison:** Phase 2 will compare per-asset specialist SAC (upper bound) against a single generalist asset-conditioned SAC to measure the *transfer gap*.
4. **Environment & Dependency Compatibility:** Strict pinning ensures zero dependency conflicts on Python 3.11: `citylearn==3.0.2`, `gymnasium==0.28.1`, `numpy==1.26.4`, `scikit-learn==1.2.2`, `stable-baselines3==2.0.0`, `mlflow>=3.0.0`, `dvc>=3.50.0`, `sqlalchemy>=2.0.30,<2.1`.
5. **Data Quality & Leakage Protection:** EV charger sessions operate with discrete arrival/departure states. Rolling lag features and observation normalizers strictly fit only on the training split to eliminate data leakage.

---

## 2. Phase 1 Deliverables Checklist

- [x] **Git Repository Structure:** Modular structure (`src/rle/`, `configs/`, `scripts/`, `tests/`, `reports/`).
- [x] **Dataset Acquisition & Catalog:** Direct reproducible fetcher (`scripts/fetch_data.py`), documented in [`DATASETS.md`](DATASETS.md).
- [x] **DVC Dataset Versioning:** Tracked raw and processed artifacts with stage pipeline (`dvc.yaml`).
- [x] **Exploratory Data Analysis (EDA):** Automated data quality audits, correlation analysis, and 24-hour profile figures ([`reports/eda/`](reports/eda/)).
- [x] **Feature Engineering:** Strict non-leaking scalers, temporal cyclical encodings, lag and net load features ([`configs/features.yaml`](configs/features.yaml)).
- [x] **Baseline Models:**
  - Standard reference: `NoControlAgent` (normalized ratio = 1.0)
  - Rule-based controllers: `BasicRBC` and adaptive `TimeOfUseRBC`
  - Load forecasting: Persistence, Seasonal Naive, Ridge, and HistGradientBoostingRegressor
  - Reinforcement learning: Untrained-to-trained Soft Actor-Critic (SAC) smoke baseline
  - *(Phase 2)* Per-asset specialist SAC — upper bound for transfer evaluation
  - *(Phase 2)* Generalist asset-conditioned SAC — single policy tested at L1/L2/L3
  - *(Phase 2, optional)* Linear MPC baseline — optimization-based comparator
- [x] **MLflow Experiment Tracking:** SQLite tracking backend logging params, metrics, and KPI artifacts.
- [x] **Evaluation Summary:** Auto-generated KPI tables in [`reports/PHASE1_EVALUATION.md`](reports/PHASE1_EVALUATION.md). Phase 2 evaluation framework (E1–E6 experiments) documented.
- [x] **Kaggle Deployment:** Self-contained executable notebook (`notebooks/kaggle_phase1_run.ipynb`) and compute guide ([`RUNBOOK_KAGGLE.md`](RUNBOOK_KAGGLE.md)).

---

## 3. Repository Structure

```
rl-energy-controller/
├── .github/workflows/ci.yml         # Cloud CI/CD automation workflow
├── .pre-commit-config.yaml          # Enterprise code formatting & linting hooks
├── Dockerfile, Makefile             # Containerization & automation targets
├── dvc.yaml, dvc.lock, params.yaml  # DVC data/model pipeline & hyperparameters
├── pyproject.toml, requirements.lock# Pinned reproducible dependency specifications
├── DATASETS.md, RUNBOOK_KAGGLE.md   # Dataset catalog & Kaggle reproducibility guide
├── README.md                        # Project architecture & executive documentation
│
├── configs/
│   ├── descriptors/                 # Asset descriptor schemas & unseen asset configs
│   ├── features.yaml                # Feature registry (named signals for Phase 2 XAI)
│   └── scenarios.yaml               # 6-scenario specifications, buildings & asset maps
│
├── data/
│   ├── raw/                         # Raw CityLearn CSVs (89 files, DVC-tracked)
│   └── processed/                   # Engineered non-leaking feature tables
│
├── docs/
│   ├── Phase1_Plan.md               # Master Phase 1 architecture & experimental framework
│   └── phase1_professional_audit.md # Professional MLOps audit & governance report
│
├── models/                          # Model checkpoints & registry state
│
├── notebooks/
│   ├── 01_eda.ipynb                 # Interactive data exploration notebook
│   └── kaggle_phase1_run.ipynb      # Complete ready-to-run Kaggle submission notebook
│
├── reports/
│   ├── PHASE1_EVALUATION.md         # Final KPI comparison report & model selection
│   ├── baseline_kpis.csv            # Detailed district KPI metrics across all 6 scenarios
│   ├── forecast_metrics.csv         # Next-hour load forecasting benchmark metrics
│   ├── forecast_cv_metrics.csv      # Rolling time-series cross-validation metrics
│   ├── feature_importance.csv       # Permutation feature importance rankings
│   ├── multiseed_sac_smoke.csv      # Multi-seed baseline evaluation metrics
│   ├── drift_benchmark.csv          # Drift injection & KS/PSI monitor benchmarks
│   ├── gate_audit.json              # Safety promotion gate audit trail
│   ├── eda/                         # EDA quality summaries, profiles & statistical tests
│   └── figures/                     # Evaluation charts & feature importance figures
│
├── scripts/
│   ├── fetch_data.py                # Direct dataset fetcher from CityLearn source
│   ├── setup_env.sh / .bat          # Pinned environment setup
│   ├── init_repo.sh / .bat          # Git & DVC initialisation
│   ├── run_all.sh / .bat            # End-to-end headless pipeline runner
│   ├── log_to_mlflow.py             # MLflow experiment tracking logger
│   ├── run_multiseed_eval.py        # Multi-seed SAC evaluation runner
│   └── validate_phase1.py           # Comprehensive 52-check automated deliverables audit
│
├── src/
│   ├── assets/                      # Asset descriptor schema & onboarding manager
│   ├── monitor/                     # Drift injection & statistical detection benchmarks
│   ├── registry/                    # Model promotion gate & safety verification
│   └── rle/                         # Core RL Energy Controller logic
│       ├── agents.py                # NoControl, BasicRBC, TimeOfUseRBC, ForecastDriven
│       ├── features.py              # Feature engineering & strict non-leaking scaler
│       ├── build_features.py        # Feature pipeline builder
│       ├── forecast.py              # Load forecasting baselines & rolling CV
│       ├── feature_importance.py    # Permutation feature importance analysis
│       ├── run_baselines.py         # Multi-model simulation baselines & SAC RL runner
│       ├── eda.py                   # Automated EDA, statistical tests & profiles
│       ├── report.py                # Markdown evaluation report compiler
│       └── common.py                # Environment factory, KPI parser, MLflow config
│
└── tests/
    ├── conftest.py                  # Pytest fixtures & environment setup
    ├── test_assets.py               # Asset descriptor schema & vectorization tests
    ├── test_env_smoke.py            # Environment stepping & KPI smoke tests
    ├── test_features.py             # Cyclical encoding & leakage unit tests
    ├── test_monitor.py              # PSI/KS drift detection tests
    └── test_registry.py             # Safety promotion gate verification tests
```


---

## 4. Quickstart: Reproducing Locally

### Linux / macOS / WSL
```bash
# 1. Setup environment and install pinned dependencies
bash scripts/setup_env.sh

# 2. Run the full pipeline end-to-end (fast mode)
bash scripts/run_all.sh
```

### Windows (PowerShell / Command Prompt)
```cmd
# 1. Setup environment
scripts\setup_env.bat

# 2. Run the full pipeline end-to-end
scripts\run_all.bat
```

To run with full SAC training timesteps (e.g. 50,000 steps), set `P1_FAST=0`:
```bash
P1_FAST=0 bash scripts/run_all.sh
```

---

## 5. Running on Kaggle

The pipeline is pre-packaged and verified to run in under 4 minutes on Kaggle CPU/GPU kernels.
1. Open [Kaggle Notebooks](https://www.kaggle.com/code).
2. Click **File -> Import Notebook** and upload `notebooks/kaggle_phase1_run.ipynb`.
3. In the sidebar, ensure **Internet is ON**.
4. Click **Run All**.
5. See [`RUNBOOK_KAGGLE.md`](RUNBOOK_KAGGLE.md) for detailed performance metrics, memory footprints, and troubleshooting.
