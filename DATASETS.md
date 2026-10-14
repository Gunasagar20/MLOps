# Dataset Provenance, Licences, and Catalog

**Project:** Explainable RL Controller for Flexible Energy Assets in Buildings  
**Repository:** `citylearn-project/CityLearn`  
**Pinned Commit:** `834575c1a0194c8ae9d648ae858376a94dfceb78` (branch: `master`)  
**Licence:** MIT License (CityLearn framework) / NREL End-Use Load Profiles (EULP) & Open Energy Data terms  
**Citation:**  
> Vázquez-Canteli, J. R., Dey, S., Henze, G., & Nagy, Z. (2020). *CityLearn: Standardizing Research in Multi-Agent Reinforcement Learning for Demand Response.* In Proceedings of the 7th ACM International Conference on Systems for Energy-Efficient Buildings, Cities, and Transportation (BuildSys '20). https://doi.org/10.1145/3408308.3427623

---

## 1. Scenario Catalog

### S1: HVAC & Thermal Energy Storage (CityLearn Challenge 2023 & 2020)
- **Primary Smoke / Test Dataset:** `citylearn_challenge_2023_phase_1`
  - **Buildings:** 3 residential / commercial buildings
  - **Timestep:** 1-hour resolution
  - **Duration:** 720 time steps (30 days)
  - **Assets:** Cooling device (heat pump), domestic hot water (DHW) storage tank, electrical battery storage, solar PV
  - **Actions:** `dhw_storage`, `electrical_storage`, `cooling_device`
  - **Tariff & Carbon:** Dynamic electricity pricing (`pricing.csv`, spread ~1.0x), time-varying grid carbon intensity (`carbon_intensity.csv`)

- **Multi-Climate Zone Generalization Datasets:**
  - `citylearn_challenge_2020_climate_zone_1` (Hot humid / tropical, 9 buildings, 8,760 hours)
  - `citylearn_challenge_2020_climate_zone_2` (Mixed humid, 9 buildings, 8,760 hours)
  - `citylearn_challenge_2020_climate_zone_3` (Hot dry, 9 buildings, 8,760 hours)
  - `citylearn_challenge_2020_climate_zone_4` (Marine / mild, 9 buildings, 8,760 hours)
  - **Assets:** Cooling storage, DHW storage, electrical storage, PV
  - **Pricing:** Constant/flat tariff (cost KPI ratio is 1.0; primary optimization goals are carbon emissions, daily peak, and load factor)

### S2: Electric Vehicle & Flexible Battery Integration
- **Primary EV Dataset:** `citylearn_challenge_2022_phase_all_plus_evs`
  - **Buildings:** 17 buildings
  - **Timestep:** 1-hour resolution
  - **Duration:** 8,760 time steps (1 full year)
  - **Assets:** Electrical battery storage, Solar PV, Electric Vehicle chargers (`charger_*.csv`), deferrable appliances
  - **Actions:** `electrical_storage`, `electric_vehicle_storage`, `deferrable_appliance`
  - **Charger profiles:** Discrete EV arrival/departure sessions, departure target SOC (State of Charge), charger efficiency (95%), nominal power (7.4 kW)
  - **Pricing & Carbon:** Highly variable electricity pricing (0.139 to 0.165+ EUR/kWh), hourly carbon intensity

---

## 2. File Schema & Data Dictionary

| File Pattern | Description | Key Columns / Signals |
|---|---|---|
| `Building_*.csv` | Building load & environmental simulation | `month`, `hour`, `day_type`, `daylight_savings_status`, `indoor_dry_bulb_temperature`, `average_unmet_cooling_setpoint_difference`, `indoor_relative_humidity`, `non_shiftable_load`, `dhw_demand`, `cooling_demand`, `heating_demand`, `solar_generation`, `occupant_count` |
| `weather.csv` | Ambient weather measurements and forecasts | `outdoor_dry_bulb_temperature`, `outdoor_relative_humidity`, `diffuse_solar_irradiance`, `direct_solar_irradiance`, and lookahead predictions (`*_predicted_1`, `*_predicted_2`, `*_predicted_3`) |
| `pricing.csv` | Electricity pricing signals | `electricity_pricing`, `electricity_pricing_predicted_1..3` |
| `carbon_intensity.csv` | Grid greenhouse gas intensity | `carbon_intensity` (kg CO2e / kWh) |
| `charger_*_*.csv` | EV charger session log | `electric_vehicle_charger_state` (1=unconnected, 2=connected/not charging, 3=charging), `electric_vehicle_id`, `electric_vehicle_departure_time`, `electric_vehicle_required_soc_departure` |
| `schema.json` | CityLearn scenario configuration | Defines buildings, active action spaces, reward weights, simulation timesteps, and episode boundaries |

---

## 3. Storage & Versioning
- Raw and processed data are tracked with **DVC** (`dvc add data/raw/...`).
- Lightweight metadata pointers (`*.dvc`, `dvc.lock`) are version-controlled in Git.
- Local reproducible cache supported, with optional cloud remotes (Google Drive / S3 / DagsHub).
