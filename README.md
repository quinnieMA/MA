### Color Coding Legend
| Color Symbol | Type               | Purpose                                                                 |
|--------------|--------------------|-------------------------------------------------------------------------|
| 🔴 Red       | Primary Key        | Marks the unique identifier (`deal_num`) that uniquely identifies each deal |
| 🟢 Green     | Deduplication Key  | Marks fields used to eliminate duplicate records for related entities   |
## MA firm financial information ##
#### **Basic Deal Information**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Deal Number | 🔴 `deal_num` |
| Deal type | `deal_type` |
| Deal status | `deal_status` |

#### **Entity Identifiers**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Target name | 🟢`tar_name` |
| Target BvD ID number |🟢 `tar_bvd_id_num` |
| Target Orbis ID number | 🟢`tar_orbis_id_num` |
| Acquiror name | 🟢`acq_name` |
| Acquiror BvD ID number |🟢 `acq_bvd_id_num` |
| Acquiror Orbis ID number | 🟢`acq_orbis_id_num` |
| Vendor name |`ven_name` |
| Vendor BvD ID number |`ven_bvd_id_num` |
| Vendor Orbis ID number | `ven_orbis_id_num` |
| Acquiror country code | `acq_country` |
| Target country code | `tar_country` |

#### **Deal Value Metrics**
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Deal value th USD | `DV` |
| Deal value (Native currency) th USD | `DV_local` |
| Deal equity value th USD | `EQV` |
| Deal equity value (Native currency) th USD | `EQV_local` |
| Deal enterprise value th USD | `EV` |
| Deal enterprise value (Native currency) th USD | `EV_local` |
| Deal modelled enterprise value th USD | `MEV` |
| Deal modelled enterprise value (Native currency) th USD | `MEV_local` |
| Deal total target value th USD | `T_tar_value` |
| Deal total target value (Native currency) th USD | `T_tar_value_local` |
| Modelled Fee Income th USD | `M_fee` |
| As Reported Fee Income th USD | `reported_fee` |

### 3. **Financial Abbreviation Dictionary**

| Term Pattern | Abbreviation | Description |
|--------------|--------------|-------------|
| acquiror | `acq` | Acquiror entity |
| target | `tar` | Target entity |
| vendor | `ven` | Vendor entity |
| operating revenue, revenue, turnover | `rev` | Revenue metrics |
| ebitda | `ebitda` | EBITDA |
| ebit | `ebit` | EBIT |
| profit before tax | `pbt` | Profit before tax |
| profit after tax | `pat` | Profit after tax |
| net profit | `np` | Net profit |
| total assets | `ta` | Total assets |
| net assets | `na` | Net assets |
| shareholders funds | `eq` | Shareholders equity |
| market capitalisation | `cap` | Market cap |
| number of employees | `emp` | Employee count |
| enterprise value | `ev` | Enterprise value |
| earnings per share | `eps` | EPS |
| cash flow per share | `cfps` | CFPS |
| dividend per share | `dps` | DPS |
| book value per share | `bvps` | BVPS |
| last avail yr | `ly` | Last available year |
| year 1 | `y1` | Year 1 |
| year 2 | `y2` | Year 2 |
| first | `1st` | First available |
| future | `fut` | Future estimates |
| multiple | `mul` | Multiple values |
| estimate | `est` | Estimates |
| year | `yr` | Year indicator |

### 4. **Prefix Handling**
| Pattern | Standardized |
|---------|--------------|
| pre_deal_ | `pre_` |
| post_deal_ | `post_` |

### 5. **Entity Type Normalization**
| Pattern | Standardized |

# Legal Data Batch Processing Tool

## Overview
This Python script batch processes Excel files containing M&A legal entity data, standardizing column names for consistent downstream processing in Stata.

## Color Coding Legend
| Color Symbol | Type | Purpose |
|--------------|------|---------|
| 🔴 Red | Primary Key | Marks the unique identifier (`deal_num`) that uniquely identifies each deal |
| 🟢 Green | Deduplication Key | Marks fields used to eliminate duplicate records for related entities |

## Configuration
| Parameter | Value |
|-----------|-------|
| Input Directory | `C:\Users\FM\OneDrive\MA\acquisition\legal` |
| Output Format | CSV (utf-8-sig encoded) |
| Output Subdirectory | `cleaned_output` |

## Column Mapping Rules

### 1. Direct Pattern Matching
The script uses regex patterns to map raw column names to standardized outputs:

#### Deal Information
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Deal Number | 🔴`deal_num` |

#### Target Company Legal Attributes
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Target name | 🟢`tar_name` |
| Target BvD ID number | 🟢`tar_bvd_id_num` |
| Target Orbis ID number | 🟢`tar_orbis_id_num` |
| Target status | `tar_status` |
| Target entity type | `tar_ent_type` |
| Target legal form | `tar_legal_form` |
| Target date of incorporation | `tar_incorp_d` |
| Target BvD independence indicator | `tar_bvd_indep` |
| Target available accounts type(s) | `tar_acct_types` |
| Target filing type | `tar_filing_type` |
| Target latest accounts date | `tar_last_acct_d` |
| Target accounts published in | `tar_acct_pub` |

#### Acquiror Company Legal Attributes
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Acquiror name | 🟢`acq_name` |
| Acquiror BvD ID number | 🟢`acq_bvd_id_num` |
| Acquiror Orbis ID number | 🟢`acq_orbis_id_num` |
| Acquiror status | `acq_status` |
| Acquiror entity type | `acq_ent_type` |
| Acquiror legal form | `acq_legal_form` |
| Acquiror date of incorporation | `acq_incorp_d` |
| Acquiror BvD independence indicator | `acq_bvd_indep` |
| Acquiror available accounts type(s) | `acq_acct_types` |
| Acquiror filing type | `acq_filing_type` |
| Acquiror latest accounts date | `acq_last_acct_d` |
| Acquiror accounts published in | `acq_acct_pub` |

#### Vendor Company Legal Attributes
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Vendor name | 🟢`ven_name` |
| Vendor BvD ID number | 🟢`ven_bvd_id_num` |
| Vendor Orbis ID number | 🟢`ven_orbis_id_num` |
| Vendor status | `ven_status` |
| Vendor entity type | `ven_ent_type` |
| Vendor legal form | `ven_legal_form` |
| Vendor date of incorporation | `ven_incorp_d` |
| Vendor BvD independence indicator | `ven_bvd_indep` |
| Vendor available accounts type(s) | `ven_acct_types` |
| Vendor filing type | `ven_filing_type` |
| Vendor latest accounts date | `ven_last_acct_d` |
| Vendor accounts published in | `ven_acct_pub` |

### 2. Financial Abbreviation Dictionary
The script applies the following abbreviations to all column names:

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

### 3. Year Suffix Patterns
| Original Pattern | Standardized Output |
|-----------------|---------------------|
| Last avail. yr | `_ly` |
| Year - 1 | `_y1` |
| Year - 2 | `_y2` |
| th USD | `_usd` |
| 1st avail | `_1st` |

### 4. Post-Processing Cleanup
After abbreviation application, the script performs:
- Remove: `th usd`, `usd`, `th`, `(.*?)`
- Replace non-alphanumeric characters with underscores
- Collapse multiple underscores
- Handle duplicate column names with numeric suffixes

## Resulting Variable Structure

### Core Entity Identifiers (10 fields)
| Entity | Name | BvD ID | Orbis ID |
|--------|------|--------|----------|
| Target | 🟢`tar_name` | 🟢`tar_bvd_id_num` | 🟢`tar_orbis_id_num` |
| Acquiror | 🟢`acq_name` | 🟢`acq_bvd_id_num` | 🟢`acq_orbis_id_num` |
| Vendor | 🟢`ven_name` | 🟢`ven_bvd_id_num` | 🟢`ven_orbis_id_num` |

### Legal Status Variables (27 fields)

#### Target Company Legal Variables (9 fields)
| Variable | Description |
|----------|-------------|
| `tar_status` | Target company status (Active/Inactive/etc.) |
| `tar_ent_type` | Target entity type (Corporation/LLC/etc.) |
| `tar_legal_form` | Target legal form (Public/Private/etc.) |
| `tar_incorp_d` | Target incorporation date |
| `tar_bvd_indep` | Target BvD independence indicator |
| `tar_acct_types` | Target available accounts type(s) |
| `tar_filing_type` | Target filing type (Consolidated/Unconsolidated) |
| `tar_last_acct_d` | Target latest accounts date |
| `tar_acct_pub` | Target accounts published in |

#### Acquiror Company Legal Variables (9 fields)
| Variable | Description |
|----------|-------------|
| `acq_status` | Acquiror company status |
| `acq_ent_type` | Acquiror entity type |
| `acq_legal_form` | Acquiror legal form |
| `acq_incorp_d` | Acquiror incorporation date |
| `acq_bvd_indep` | Acquiror BvD independence indicator |
| `acq_acct_types` | Acquiror available accounts type(s) |
| `acq_filing_type` | Acquiror filing type |
| `acq_last_acct_d` | Acquiror latest accounts date |
| `acq_acct_pub` | Acquiror accounts published in |

#### Vendor Company Legal Variables (9 fields)
| Variable | Description |
|----------|-------------|
| `ven_status` | Vendor company status |
| `ven_ent_type` | Vendor entity type |
| `ven_legal_form` | Vendor legal form |
| `ven_incorp_d` | Vendor incorporation date |
| `ven_bvd_indep` | Vendor BvD independence indicator |
| `ven_acct_types` | Vendor available accounts type(s) |
| `ven_filing_type` | Vendor filing type |
| `ven_last_acct_d` | Vendor latest accounts date |
| `ven_acct_pub` | Vendor accounts published in |

### Variable Count Summary
| Category | Count |
|----------|-------|
| Entity Identifiers | 10 |
| Target Legal Variables | 9 |
| Acquiror Legal Variables | 9 |
| Vendor Legal Variables | 9 |
| Deal Number | 1 |
| **Total Variables** | **38** |

## Processing Workflow

|---------|--------------|
| _target_ | `_tar_` |
| _acquiror_ | `_acq_` |
| _vendor_ | `_ven_` |
