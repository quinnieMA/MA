### Color Coding Legend
| Color Symbol | Type               | Purpose                                                                 |
|--------------|--------------------|-------------------------------------------------------------------------|
| 🔴 Red       | Primary Key        | Marks the unique identifier (`deal_num`) that uniquely identifies each deal |
| 🟢 Green     | Deduplication Key  | Marks fields used to eliminate duplicate records for related entities   |

## Deal multiple ##
#### ** Deal Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Deal Number | 🔴`deal_num` |
| Acquiror name | 🟢`acq_name` |
| Target name | 🟢`tar_name` |
| Vendor name | 🟢’ven_name` |

#### **Value Multiples (Pre-deal & Post-deal)**
| Multiple Type | Pre-deal Output | Post-deal Output |
|--------------|-----------------|------------------|
| Operating Revenue/Turnover | `pre_rev_mul` | `post_rev_mul` |
| EBITDA | `pre_ebitda_mul` | `post_ebitda_mul` |
| EBIT | `pre_ebit_mul` | `post_ebit_mul` |
| Profit Before Tax | `pre_pbt_mul` | `post_pbt_mul` |
| Profit After Tax | `pre_pat_mul` | `post_pat_mul` |
| Net Profit | `pre_np_mul` | `post_np_mul` |
| Total Assets | `pre_ta_mul` | `post_ta_mul` |
| Net Assets | `pre_na_mul` | `post_na_mul` |
| Current Liabilities | `pre_cl_mul` | `post_cl_mul` |
| Shareholders Funds | `pre_eq_mul` | `post_eq_mul` |
| Market Capitalisation | `pre_cap_mul` | `post_cap_mul` |


## Deal structure_date ##
#### **Deal Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Unnamed: 0 | `unnamed_0` |
| Deal Number | 🔴`deal_num` |
| Deal type | `deal_type` |
| Deal structure | `deal_struct` |
| Deal financing | `deal_fin` |
| Deal method of payment | `deal_pay_method` |
| Deal method of payment value th USD | `deal_pay_method_val_usd` |
| Deal status | `deal_status` |

#### **Date Fields**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Rumour date | `rumour_d` |
| Announced date | `announced_d` |
| Expected completion date | `expected_comp_d` |
| Assumed completion date | `assumed_comp_d` |
| Completed date | `completed_d` |
| Postponed date | `postponed_d` |
| Withdrawn date | `withdrawn_d` |
| Last deal status date | `last_deal_status_d` |
| Last deal value, offer price, bid premium update date | `last_deal_val_up_d` |
| Last deal status update date | `last_deal_status_up_d` |
| Last % of stake update date | `last_pct_stake_up_d` |
| Last acquiror, target, vendor update date | `last_acq_tar_ven_up_d` |
| Last advisor update date | `last_advisor_up_d` |
| Last deal comment, rationale update date | `last_comment_up_d` |
| Last update | `last_up` |

#### **Year Fields** (Derived from Dates)
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| rumour_date_year | `rumour_d_yr` |
| announced_date_year | `announced_d_yr` |
| expected_completion_date_year | `expected_comp_d_yr` |
| assumed_completion_date_year | `assumed_comp_d_yr` |
| completed_date_year | `completed_d_yr` |
| postponed_date_year | `postponed_d_yr` |
| withdrawn_date_year | `withdrawn_d_yr` |
| last_deal_status_date_year | `last_deal_status_d_yr` |
| last_deal_value_offer_price_bid_premium_update_date_year | `last_deal_val_up_d_yr` |
| last_deal_status_update_date_year | `last_deal_status_up_d_yr` |
| last_pct_of_stake_update_date_year | `last_pct_stake_up_d_yr` |
| last_acquiror_target_vendor_update_date_year | `last_acq_tar_ven_up_d_yr` |
| last_advisor_update_date_year | `last_advisor_up_d_yr` |
| last_deal_comment_rationale_update_date_year | `last_comment_up_d_yr` |
| last_update_year | `last_up_yr` |

## Deal value ##
### 1. Core Deal Information
Foundational identifiers for M&A transactions (no suffix variants):

| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| Deal Number | 🔴`deal_num` |
| Acquiror name |🟢 `acq_name` |
| Target name |🟢 `tar_name` |
| Vendor name |🟢 `ven_name` |
| **Total** | **4 fields** |

### 2. Deal Value Metrics
Monetary values for deals (11 base fields × 3 suffix variants = 33 total):

| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| Deal value (Native currency) | `dv_local` |
| Deal value | `dv_usd` |
| Deal equity value (Native currency) | `eqv_local` |
| Deal equity value | `eqv_usd` |
| Deal enterprise value (Native currency) | `ev_local` |
| Deal enterprise value | `ev_usd` |
| Deal modelled enterprise value (Native currency) | `mev_local` |
| Deal modelled enterprise value | `mev_usd` |
| Deal total target value (Native currency) | `ttv_local` |
| Deal total target value | `ttv_usd` |
| Modelled Fee Income | `modeled_fee` |
| As Reported Fee Income | `reported_fee` |
| **Total Base Fields** | **11 fields** |

### 3. Deal Structure Metrics
Structural and performance indicators (5 base fields × 3 suffix variants = 15 total):

| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| Initial stake (%) | `stake_init_pct` |
| Acquired stake (%) | `stake_acq_pct` |
| Final stake (%) | `stake_final_pct` |
| IRR (%) | `irr_pct` |
| Native currency | `currency` |
| **Total Base Fields** | **5 fields** |

### 4. Company Financial Metrics
Financial indicators for Target/Acquiror/Vendor (16 metrics × 3 entity types = 48 base fields × 3 suffix variants = 144 total):

Each metric is standardized for **Target (tar_)**, **Acquiror (acq_)**, and **Vendor (ven_)**:

| Raw Column Pattern | Standardized Name (Target Example) |
|--------------------|------------------------------------|
| [Entity] operating revenue/turnover | `tar_rev` |
| [Entity] EBITDA | `tar_ebitda` |
| [Entity] EBIT | `tar_ebit` |
| [Entity] profit before tax | `tar_pbt` |
| [Entity] profit after tax | `tar_pat` |
| [Entity] net profit | `tar_np` |
| [Entity] total assets | `tar_ta` |
| [Entity] net assets | `tar_na` |
| [Entity] shareholders funds | `tar_eq` |
| [Entity] market capitalisation | `tar_cap` |
| [Entity] number of employees | `tar_emp` |
| [Entity] enterprise value | `tar_ev` |
| [Entity] earnings per share | `tar_eps` |
| [Entity] cash flow per share | `tar_cfps` |
| [Entity] dividend per share | `tar_dps` |
| [Entity] book value per share | `tar_bvps` |
| **Total Base Fields** | **48 fields (3 entities × 16 metrics)** |

## Deal overview ## 
### A. Company Overview Information
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| [Target/Acquiror/Vendor] overview | `tar_overview` / `acq_overview` / `ven_overview` |
| [Target/Acquiror/Vendor] major sector | `tar_major_sector` / `acq_major_sector` / `ven_major_sector` |
| [Target/Acquiror/Vendor] trade description (english) | `tar_trade_descr_en` / `acq_trade_descr_en` / `ven_trade_descr_en` |
| [Target/Acquiror/Vendor] trade description (original language) | `tar_trade_descr_orig` / `acq_trade_descr_orig` / `ven_trade_descr_orig` |
| [Target/Acquiror/Vendor] primary business description | `tar_primary_busi_descr` / `acq_primary_busi_descr` / `ven_primary_busi_descr` |
| [Target/Acquiror/Vendor] business description(s) | `tar_busi_descr` / `acq_busi_descr` / `ven_busi_descr` |

### B. Company Identifiers
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| [Target/Acquiror/Vendor] name | 🟢`tar_name` /🟢 `acq_name` / 🟢`ven_name` |
| [Target/Acquiror/Vendor] BvD ID number | 🟢`tar_bvd_id_num` / 🟢`acq_bvd_id_num` / 🟢`ven_bvd_id_num` |
| [Target/Acquiror/Vendor] Orbis ID number | 🟢`tar_orbis_id_num` / 🟢`acq_orbis_id_num` / 🟢`ven_orbis_id_num` |

### C. Industry Classification Codes (5 Classification Systems)

#### 1. BvD Sector (Bureau van Dijk Industry Classification)
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| primary BvD Sector code | `tar_primary_bvd_code` / `acq_primary_bvd_code` / `ven_primary_bvd_code` |
| primary BvD Sector description | `tar_primary_bvd_descr` / `acq_primary_bvd_descr` / `ven_primary_bvd_descr` |
| BvD Sector code(s) | `tar_bvd_codes` / `acq_bvd_codes` / `ven_bvd_codes` |
| BvD Sector description(s) | `tar_bvd_descr` / `acq_bvd_descr` / `ven_bvd_descr` |

#### 2. US SIC (Standard Industrial Classification)
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| primary US SIC code | `tar_primary_sic_code` / `acq_primary_sic_code` / `ven_primary_sic_code` |
| primary US SIC description | `tar_primary_sic_descr` / `acq_primary_sic_descr` / `ven_primary_sic_descr` |
| US SIC code(s) | `tar_sic_codes` / `acq_sic_codes` / `ven_sic_codes` |
| US SIC description(s) | `tar_sic_descr` / `acq_sic_descr` / `ven_sic_descr` |

#### 3. UK SIC 2007 (UK Standard Industrial Classification 2007)
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| primary UK SIC (2007) code | `tar_primary_uk_sic_code` / `acq_primary_uk_sic_code` / `ven_primary_uk_sic_code` |
| primary UK SIC (2007) description | `tar_primary_uk_sic_descr` / `acq_primary_uk_sic_descr` / `ven_primary_uk_sic_descr` |
| UK SIC (2007) code(s) | `tar_uk_sic_codes` / `acq_uk_sic_codes` / `ven_uk_sic_codes` |
| UK SIC (2007) description(s) | `tar_uk_sic_descr` / `acq_uk_sic_descr` / `ven_uk_sic_descr` |

#### 4. NACE Rev.2 (EU Industrial Classification)
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| primary NACE Rev.2 code | `tar_primary_nace_code` / `acq_primary_nace_code` / `ven_primary_nace_code` |
| primary NACE Rev.2 description | `tar_primary_nace_descr` / `acq_primary_nace_descr` / `ven_primary_nace_descr` |
| NACE Rev.2 code(s) | `tar_nace_codes` / `acq_nace_codes` / `ven_nace_codes` |
| NACE Rev.2 description(s) | `tar_nace_descr` / `acq_nace_descr` / `ven_nace_descr` |

#### 5. NAICS 2017 (North American Industry Classification System 2017)
| Raw Column Name | Standardized Name |
|-----------------|-------------------|
| primary NAICS 2017 code | `tar_primary_naics_code` / `acq_primary_naics_code` / `ven_primary_naics_code` |
| primary NAICS 2017 description | `tar_primary_naics_descr` / `acq_primary_naics_descr` / `ven_primary_naics_descr` |
| NAICS 2017 code(s) | `tar_naics_codes` / `acq_naics_codes` / `ven_naics_codes` |
| NAICS 2017 description(s) | `tar_naics_descr` / `acq_naics_descr` / `ven_naics_descr` |

## Year Suffix Handling ##
| Year Pattern | Suffix |
|--------------|--------|
| Last avail. yr | `_ly` |
| First avail. yr | `_fy` |
| Year - 1 | `_y1` |
| Year - 2 | `_y2` |

## Deal industry information ##
#### **Deal Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Deal Number | 🔴`deal_num` |
| Target name | 🟢`tar_name` |
| Target BvD ID number | 🟢`tar_bvd_id_num` |
| Target Orbis ID number | `tar_orbis_id_num` |
| Acquiror name | 🟢`acq_name` |
| Acquiror BvD ID number |🟢 `acq_bvd_id_num` |
| Acquiror Orbis ID number | `acq_orbis_id_num` |
| Vendor name |🟢 `ven_name` |
| Vendor BvD ID number | 🟢`ven_bvd_id_num` |
| Vendor Orbis ID number | `ven_orbis_id_num` |

#### **Target Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Target overview | `tar_overview` |
| Target major sector | `tar_major_sector` |
| Target trade description (english) | `tar_trade_descr_en` |
| Target trade description (original language) | `tar_trade_descr_orig` |
| Target primary business description | `tar_primary_busi_descr` |
| Target business description(s) | `tar_busi_descr` |

#### **Target Sector Codes**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Target primary BvD Sector code | `tar_primary_bvd_code` |
| Target primary BvD Sector description | `tar_primary_bvd_descr` |
| Target BvD Sector code(s) | `tar_bvd_codes` |
| Target BvD Sector description(s) | `tar_bvd_descr` |
| Target primary US SIC code | `tar_primary_sic_code` |
| Target primary US SIC description | `tar_primary_sic_descr` |
| Target US SIC code(s) | `tar_sic_codes` |
| Target US SIC description(s) | `tar_sic_descr` |
| Target primary UK SIC (2007) code | `tar_primary_uk_sic_code` |
| Target primary UK SIC (2007) description | `tar_primary_uk_sic_descr` |
| Target UK SIC (2007) code(s) | `tar_uk_sic_codes` |
| Target UK SIC (2007) description(s) | `tar_uk_sic_descr` |
| Target primary NACE Rev.2 code | `tar_primary_nace_code` |
| Target primary NACE Rev.2 description | `tar_primary_nace_descr` |
| Target NACE Rev.2 code(s) | `tar_nace_codes` |
| Target NACE Rev.2 description(s) | `tar_nace_descr` |
| Target primary NAICS 2017 code | `tar_primary_naics_code` |
| Target primary NAICS 2017 description | `tar_primary_naics_descr` |
| Target NAICS 2017 code(s) | `tar_naics_codes` |
| Target NAICS 2017 description(s) | `tar_naics_descr` |

#### **Acquiror Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Acquiror overview | `acq_overview` |
| Acquiror major sector | `acq_major_sector` |
| Acquiror trade description (english) | `acq_trade_descr_en` |
| Acquiror trade description (original language) | `acq_trade_descr_orig` |
| Acquiror primary business description | `acq_primary_busi_descr` |
| Acquiror business description(s) | `acq_busi_descr` |
| Acquiror primary BvD Sector code | `acq_primary_bvd_code` |
| Acquiror primary BvD Sector description | `acq_primary_bvd_descr` |
| Acquiror BvD Sector code(s) | `acq_bvd_codes` |
| Acquiror BvD Sector description(s) | `acq_bvd_descr` |
| Acquiror primary US SIC code | `acq_primary_sic_code` |
| Acquiror primary US SIC description | `acq_primary_sic_descr` |
| Acquiror US SIC code(s) | `acq_sic_codes` |
| Acquiror US SIC description(s) | `acq_sic_descr` |
| Acquiror primary UK SIC (2007) code | `acq_primary_uk_sic_code` |
| Acquiror primary UK SIC (2007) description | `acq_primary_uk_sic_descr` |
| Acquiror UK SIC (2007) code(s) | `acq_uk_sic_codes` |
| Acquiror UK SIC (2007) description(s) | `acq_uk_sic_descr` |
| Acquiror primary NACE Rev.2 code | `acq_primary_nace_code` |
| Acquiror primary NACE Rev.2 description | `acq_primary_nace_descr` |
| Acquiror NACE Rev.2 code(s) | `acq_nace_codes` |
| Acquiror NACE Rev.2 description(s) | `acq_nace_descr` |
| Acquiror primary NAICS 2017 code | `acq_primary_naics_code` |
| Acquiror primary NAICS 2017 description | `acq_primary_naics_descr` |
| Acquiror NAICS 2017 code(s) | `acq_naics_codes` |
| Acquiror NAICS 2017 description(s) | `acq_naics_descr` |

#### **Vendor Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Vendor overview | `ven_overview` |
| Vendor major sector | `ven_major_sector` |
| Vendor trade description (english) | `ven_trade_descr_en` |
| Vendor trade description (original language) | `ven_trade_descr_orig` |
| Vendor primary business description | `ven_primary_busi_descr` |
| Vendor business description(s) | `ven_busi_descr` |
| Vendor primary BvD Sector code | `ven_primary_bvd_code` |
| Vendor primary BvD Sector description | `ven_primary_bvd_descr` |
| Vendor BvD Sector code(s) | `ven_bvd_codes` |
| Vendor BvD Sector description(s) | `ven_bvd_descr` |
| Vendor primary US SIC code | `ven_primary_sic_code` |
| Vendor primary US SIC description | `ven_primary_sic_descr` |
| Vendor US SIC code(s) | `ven_sic_codes` |
| Vendor US SIC description(s) | `ven_sic_descr` |
| Vendor primary UK SIC (2007) code | `ven_primary_uk_sic_code` |
| Vendor primary UK SIC (2007) description | `ven_primary_uk_sic_descr` |
| Vendor UK SIC (2007) code(s) | `ven_uk_sic_codes` |
| Vendor UK SIC (2007) description(s) | `ven_uk_sic_descr` |
| Vendor primary NACE Rev.2 code | `ven_primary_nace_code` |
| Vendor primary NACE Rev.2 description | `ven_primary_nace_descr` |
| Vendor NACE Rev.2 code(s) | `ven_nace_codes` |
| Vendor NACE Rev.2 description(s) | `ven_nace_descr` |
| Vendor primary NAICS 2017 code | `ven_primary_naics_code` |
| Vendor primary NAICS 2017 description | `ven_primary_naics_descr` |
| Vendor NAICS 2017 code(s) | `ven_naics_codes` |
| Vendor NAICS 2017 description(s) | `ven_naics_descr` |

#### **Year Suffix Patterns**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Last avail. yr | `_ly` |
| Year - 1 | `_y1` |
| Year - 2 | `_y2` |
| th USD | `_usd` |
| 1st avail | `_1st` |

#### **通用缩写转换**
| Original Term | Standardized Output |
|-----------------|---------------------|
| acquiror | `acq` |
| target | `tar` |
| vendor | `ven` |
| group | `gr` |
| number | `num` |
| description | `descr` |
| business | `busi` |
| last avail yr | `ly` |
| year 1 | `y1` |
| year 2 | `y2` |
| first | `1st` |
| future | `fut` |
| multiple | `mul` |
| estimate | `est` |
| year | `yr` |
