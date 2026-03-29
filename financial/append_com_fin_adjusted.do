// Define the base path to OneDrive
global ONEDRIVE_PATH "D:/OneDrive"  // Change this to match your OneDrive path
// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
    
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars ïunnamed__0 deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num
    
    foreach var of local str_vars {
        capture confirm variable `var'
        if _rc == 0 {  // 只有当变量存在时才处理
            local vartype: type `var'
            if substr("`vartype'", 1, 3) != "str" {
                di "将变量 `var' 从 `vartype' 转换为字符串格式"
                tostring `var', replace force
                replace `var' = "" if `var' == "."
            }
        }
    }
	    local vars_to_process ïunnamed__0 deal_num tar_rev_rev_last_avail_yr tar_rev_rev_yr__1 tar_rev_rev_yr__2 tar_ebitda_last_avail_yr tar_ebitda_yr__1 tar_ebitda_yr__2 tar_ebit_last_avail_yr tar_ebit_yr__1 tar_ebit_yr__2 tar_pbt_last_avail_yr tar_pbt_yr__1 tar_pbt_yr__2 tar_pat_last_avail_yr tar_pat_yr__1 tar_pat_yr__2 tar_np_last_avail_yr tar_np_yr__1 tar_np_yr__2 tar_ta_last_avail_yr tar_ta_yr__1 tar_ta_yr__2 tar_na_last_avail_yr tar_na_yr__1 tar_na_yr__2 tar_eq_last_avail_yr tar_eq_yr__1 tar_eq_yr__2 tar_cap_last_avail_yr tar_cap_yr__1 tar_cap_yr__2 tar_emp_last_avail_yr tar_emp_yr__1 tar_emp_yr__2 tar_ev_last_avail_yr tar_ev_yr__1 tar_ev_yr__2 tar_eps_last_avail_yr tar_eps_yr__1 tar_eps_yr__2 tar_cfps_last_avail_yr tar_cfps_yr__1 tar_cfps_yr__2 tar_dps_last_avail_yr tar_dps_yr__1 tar_dps_yr__2 tar_bvps_last_avail_yr tar_bvps_yr__1 tar_bvps_yr__2 acq_rev_rev_last_avail_yr acq_rev_rev_yr__1 acq_rev_rev_yr__2 acq_ebitda_last_avail_yr acq_ebitda_yr__1 acq_ebitda_yr__2 acq_ebit_last_avail_yr acq_ebit_yr__1 acq_ebit_yr__2 acq_pbt_last_avail_yr acq_pbt_yr__1 acq_pbt_yr__2 acq_pat_last_avail_yr acq_pat_yr__1 acq_pat_yr__2 acq_np_last_avail_yr acq_np_yr__1 acq_np_yr__2 acq_ta_last_avail_yr acq_ta_yr__1 acq_ta_yr__2 acq_na_last_avail_yr acq_na_yr__1 acq_na_yr__2 acq_eq_last_avail_yr acq_eq_yr__1 acq_eq_yr__2 acq_cap_last_avail_yr acq_cap_yr__1 acq_cap_yr__2 acq_emp_last_avail_yr acq_emp_yr__1 acq_emp_yr__2 acq_ev_last_avail_yr acq_ev_yr__1 acq_ev_yr__2 acq_eps_last_avail_yr acq_eps_yr__1 acq_eps_yr__2 acq_cfps_last_avail_yr acq_cfps_yr__1 acq_cfps_yr__2 acq_dps_last_avail_yr acq_dps_yr__1 acq_dps_yr__2 acq_bvps_last_avail_yr acq_bvps_yr__1 acq_bvps_yr__2 ven_rev_rev_last_avail_yr ven_rev_rev_yr__1 ven_rev_rev_yr__2 ven_ebitda_last_avail_yr ven_ebitda_yr__1 ven_ebitda_yr__2 ven_ebit_last_avail_yr ven_ebit_yr__1 ven_ebit_yr__2 ven_pbt_last_avail_yr ven_pbt_yr__1 ven_pbt_yr__2 ven_pat_last_avail_yr ven_pat_yr__1 ven_pat_yr__2 ven_np_last_avail_yr ven_np_yr__1 ven_np_yr__2 ven_ta_last_avail_yr ven_ta_yr__1 ven_ta_yr__2 ven_na_last_avail_yr ven_na_yr__1 ven_na_yr__2 ven_eq_last_avail_yr ven_eq_yr__1 ven_eq_yr__2 ven_cap_last_avail_yr ven_cap_yr__1 ven_cap_yr__2 ven_emp_last_avail_yr ven_emp_yr__1 ven_emp_yr__2 ven_ev_last_avail_yr ven_ev_yr__1 ven_ev_yr__2 ven_eps_last_avail_yr ven_eps_yr__1 ven_eps_yr__2 ven_cfps_last_avail_yr ven_cfps_yr__1 ven_cfps_yr__2 ven_dps_last_avail_yr ven_dps_yr__1 ven_dps_yr__2 ven_bvps_last_avail_yr ven_bvps_yr__1 ven_bvps_yr__2  tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num

    // 第2步：识别变量类型并只对字符型变量替换"n.a."
    foreach var of local vars_to_process {
        // 获取变量类型
        capture confirm variable `var'
        if _rc {
            di "变量 `var' 不存在，跳过"
            continue
        }
        
        local vartype: type `var'
        
        // 判断是否为字符型变量
        if substr("`vartype'", 1, 3) == "str" {
            di "变量 `var' 是字符型，处理n.a.替换"
            replace `var' = "" if `var' == "n.a."|`var' == "n.s."|`var' == "-"
        }
        else {
            di "变量 `var' 是数值型(`vartype')，跳过n.a.处理"
        }
    }

    // 保存处理后的文件
    save "`output_file'", replace
    di "文件已保存: `output_file'"
end

// 主程序：处理所有文件并合并
clear

// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\financial\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\financial"

// 处理1-8号文件
forvalues i = 1/8 {
    local input_file "`input_path'\acquisition_company_financial_`i'_cleaned.csv"
    local output_file "`output_path'\acq_com_fin_`i'.dta"
    
    di "正在处理文件 `i'/8: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/8 {
    local file "`output_path'\acq_com_fin_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}

    // 定义需要处理的新变量列表
    local vars_to_process  deal_num 
// 第1步：执行前向填充（用前一个非缺失值填充当前缺失值）
    gen index =_n
    sort index
    foreach var of local vars_to_process {
        capture confirm variable `var'
        if _rc continue
        
        local vartype: type `var'
        
        // 根据不同类型处理缺失值
        if substr("`vartype'", 1, 3) == "str" {
            replace `var' = `var'[_n-1] if `var' == "" & `var'[_n-1] != ""
        }
        else {
            replace `var' = `var'[_n-1] if missing(`var') & !missing(`var'[_n-1])
        }
        di "已完成变量: `var' 的前向填充"
    }
	


	
// 检查重复观测
duplicates tag  deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num, gen(dup)

// 查看重复情况
*tab dup
*list  deal_num tar_name acq_name ven_name if dup > 0, abbreviate(5)

// 处理重复项方案1：保留第一条记录
bysort  deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num: keep if _n == 1
drop dup
	   
rename ïunnamed__0 ïunnamed_0
// 保存最终合并文件
destring  tar_rev_rev_last_avail_yr tar_rev_rev_yr__1 tar_rev_rev_yr__2 tar_ebitda_last_avail_yr tar_ebitda_yr__1 tar_ebitda_yr__2 tar_ebit_last_avail_yr tar_ebit_yr__1 tar_ebit_yr__2 tar_pbt_last_avail_yr tar_pbt_yr__1 tar_pbt_yr__2 tar_pat_last_avail_yr tar_pat_yr__1 tar_pat_yr__2 tar_np_last_avail_yr tar_np_yr__1 tar_np_yr__2 tar_ta_last_avail_yr tar_ta_yr__1 tar_ta_yr__2 tar_na_last_avail_yr tar_na_yr__1 tar_na_yr__2 tar_eq_last_avail_yr tar_eq_yr__1 tar_eq_yr__2 tar_cap_last_avail_yr tar_cap_yr__1 tar_cap_yr__2 tar_emp_last_avail_yr tar_emp_yr__1 tar_emp_yr__2 tar_ev_last_avail_yr tar_ev_yr__1 tar_ev_yr__2 tar_eps_last_avail_yr tar_eps_yr__1 tar_eps_yr__2 tar_cfps_last_avail_yr tar_cfps_yr__1 tar_cfps_yr__2 tar_dps_last_avail_yr tar_dps_yr__1 tar_dps_yr__2 tar_bvps_last_avail_yr tar_bvps_yr__1 tar_bvps_yr__2 acq_rev_rev_last_avail_yr acq_rev_rev_yr__1 acq_rev_rev_yr__2 acq_ebitda_last_avail_yr acq_ebitda_yr__1 acq_ebitda_yr__2 acq_ebit_last_avail_yr acq_ebit_yr__1 acq_ebit_yr__2 acq_pbt_last_avail_yr acq_pbt_yr__1 acq_pbt_yr__2 acq_pat_last_avail_yr acq_pat_yr__1 acq_pat_yr__2 acq_np_last_avail_yr acq_np_yr__1 acq_np_yr__2 acq_ta_last_avail_yr acq_ta_yr__1 acq_ta_yr__2 acq_na_last_avail_yr acq_na_yr__1 acq_na_yr__2 acq_eq_last_avail_yr acq_eq_yr__1 acq_eq_yr__2 acq_cap_last_avail_yr acq_cap_yr__1 acq_cap_yr__2 acq_emp_last_avail_yr acq_emp_yr__1 acq_emp_yr__2 acq_ev_last_avail_yr acq_ev_yr__1 acq_ev_yr__2 acq_eps_last_avail_yr acq_eps_yr__1 acq_eps_yr__2 acq_cfps_last_avail_yr acq_cfps_yr__1 acq_cfps_yr__2 acq_dps_last_avail_yr acq_dps_yr__1 acq_dps_yr__2 acq_bvps_last_avail_yr acq_bvps_yr__1 acq_bvps_yr__2 ven_rev_rev_last_avail_yr ven_rev_rev_yr__1 ven_rev_rev_yr__2 ven_ebitda_last_avail_yr ven_ebitda_yr__1 ven_ebitda_yr__2 ven_ebit_last_avail_yr ven_ebit_yr__1 ven_ebit_yr__2 ven_pbt_last_avail_yr ven_pbt_yr__1 ven_pbt_yr__2 ven_pat_last_avail_yr ven_pat_yr__1 ven_pat_yr__2 ven_np_last_avail_yr ven_np_yr__1 ven_np_yr__2 ven_ta_last_avail_yr ven_ta_yr__1 ven_ta_yr__2 ven_na_last_avail_yr ven_na_yr__1 ven_na_yr__2 ven_eq_last_avail_yr ven_eq_yr__1 ven_eq_yr__2 ven_cap_last_avail_yr ven_cap_yr__1 ven_cap_yr__2 ven_emp_last_avail_yr ven_emp_yr__1 ven_emp_yr__2 ven_ev_last_avail_yr ven_ev_yr__1 ven_ev_yr__2 ven_eps_last_avail_yr ven_eps_yr__1 ven_eps_yr__2 ven_cfps_last_avail_yr ven_cfps_yr__1 ven_cfps_yr__2 ven_dps_last_avail_yr ven_dps_yr__1 ven_dps_yr__2 ven_bvps_last_avail_yr ven_bvps_yr__1 ven_bvps_yr__2, replace

* 计算目标公司财务比率（统一用总资产标准化）

* 1. 盈利能力比率
gen tar_profit_margin_ly = tar_pat_last_avail_yr / tar_rev_rev_last_avail_yr if tar_rev_rev_last_avail_yr > 0
gen tar_profit_margin_y1 = tar_pat_yr__1 / tar_rev_rev_yr__1 if tar_rev_rev_yr__1 > 0
gen tar_profit_margin_y2 = tar_pat_yr__2 / tar_rev_rev_yr__2 if tar_rev_rev_yr__2 > 0

* 2. 资产收益率 (ROA)
gen tar_roa_ly =  tar_rev_rev_last_avail_yr / tar_ta_last_avail_yr if tar_ta_last_avail_yr > 0
gen tar_roa_y1 = tar_rev_rev_yr__1 / tar_ta_yr__1 if tar_ta_yr__1 > 0
gen tar_roa_y2 = tar_rev_rev_yr__2 / tar_ta_yr__2 if tar_ta_yr__2 > 0

* 3. 杠杆比率 (负债/总资产)
gen tar_leverage_ly = (tar_ta_last_avail_yr - tar_eq_last_avail_yr) / tar_ta_last_avail_yr if tar_ta_last_avail_yr > 0
gen tar_leverage_y1 = (tar_ta_yr__1 - tar_eq_yr__1) / tar_ta_yr__1 if tar_ta_yr__1 > 0
gen tar_leverage_y2 = (tar_ta_yr__2 - tar_eq_yr__2) / tar_ta_yr__2 if tar_ta_yr__2 > 0

* 4. EBITDA利润率
gen tar_ebitda_margin_ly = tar_ebitda_last_avail_yr / tar_rev_rev_last_avail_yr if tar_rev_rev_last_avail_yr > 0
gen tar_ebitda_margin_y1 = tar_ebitda_yr__1 / tar_rev_rev_yr__1 if tar_rev_rev_yr__1 > 0
gen tar_ebitda_margin_y2 = tar_ebitda_yr__2 / tar_rev_rev_yr__2 if tar_rev_rev_yr__2 > 0

* 5. 资产周转率
gen tar_asset_turnover_ly = tar_rev_rev_last_avail_yr / tar_ta_last_avail_yr if tar_ta_last_avail_yr > 0
gen tar_asset_turnover_y1 = tar_rev_rev_yr__1 / tar_ta_yr__1 if tar_ta_yr__1 > 0
gen tar_asset_turnover_y2 = tar_rev_rev_yr__2 / tar_ta_yr__2 if tar_ta_yr__2 > 0

* 6. 流动比率 (如果有流动资产数据)
* gen tar_current_ratio_ly = tar_current_assets_ly / tar_current_liabilities_ly

* 7. 人均指标
gen tar_rev_per_emp_ly = tar_rev_rev_last_avail_yr / tar_emp_last_avail_yr if tar_emp_last_avail_yr > 0
gen tar_rev_per_emp_y1 = tar_rev_rev_yr__1 / tar_emp_yr__1 if tar_emp_yr__1 > 0
gen tar_rev_per_emp_y2 = tar_rev_rev_yr__2 / tar_emp_yr__2 if tar_emp_yr__2 > 0

* 7.5 size指标
gen tar_ta = ln(tar_ta_last_avail_yr) if tar_ta_last_avail_yr > 0
gen tar_ta_y1 = ln(tar_ta_yr__1) if tar_ta_yr__1 > 0
gen tar_ta_y2 = ln(tar_ta_yr__2) if tar_ta_yr__2 > 0
gen tar_emp = ln(tar_emp_last_avail_yr) if tar_emp_last_avail_yr > 0
gen tar_emp_y1 = ln(tar_emp_yr__1) if tar_emp_yr__1 > 0
gen tar_emp_y2 = ln(tar_emp_yr__2) if tar_emp_yr__2 > 0

* 8. 估值比率 (如果EV数据可用)
gen tar_cap = ln(tar_cap_last_avail_yr) if tar_cap_last_avail_yr > 0
gen tar_cap_y1 = ln(tar_cap_yr__1) if tar_cap_yr__1 > 0
gen tar_cap_y2 = ln(tar_cap_yr__2) if tar_cap_yr__2 > 0
gen tar_ev = ln(tar_ev_last_avail_yr) if tar_ev_last_avail_yr > 0
gen tar_ev_y1 = ln(tar_ev_yr__1) if tar_ev_yr__1 > 0
gen tar_ev_y2 = ln(tar_ev_yr__2) if tar_ev_yr__2 > 0

*gen tar_ev_to_rev_ly = tar_ev_last_avail_yr / tar_rev_rev_last_avail_yr if tar_rev_rev_last_avail_yr > 0
*gen tar_ev_to_ebitda_ly = tar_ev_last_avail_yr / tar_ebitda_last_avail_yr if tar_ebitda_last_avail_yr > 0


* 9. 检查计算结果的统计特征
*sum tar_profit_margin_ly tar_roa_ly tar_leverage_ly tar_ebitda_margin_ly tar_asset_turnover_ly

* 10. 标签变量
label variable tar_profit_margin_ly "Target Profit Margin (Last Year)"
label variable tar_roa_ly "Target ROA (Last Year)" 
label variable tar_leverage_ly "Target Leverage Ratio (Last Year)"
label variable tar_ebitda_margin_ly "Target EBITDA Margin (Last Year)"
label variable tar_asset_turnover_ly "Target Asset Turnover (Last Year)"
label variable tar_rev_per_emp_ly "Target Revenue per Employee (Last Year)"


* 计算acq公司财务比率（统一用总资产标准化）

* 1. 盈利能力比率
gen acq_profit_margin_ly = acq_pat_last_avail_yr / acq_rev_rev_last_avail_yr if acq_rev_rev_last_avail_yr > 0
gen acq_profit_margin_y1 = acq_pat_yr__1 / acq_rev_rev_yr__1 if acq_rev_rev_yr__1 > 0
gen acq_profit_margin_y2 = acq_pat_yr__2 / acq_rev_rev_yr__2 if acq_rev_rev_yr__2 > 0

* 2. 资产收益率 (ROA)
gen acq_roa_ly =  acq_rev_rev_last_avail_yr/ acq_ta_last_avail_yr if acq_ta_last_avail_yr > 0
gen acq_roa_y1 =  acq_rev_rev_yr__1 / acq_ta_yr__1 if acq_ta_yr__1 > 0
gen acq_roa_y2 =  acq_rev_rev_yr__2 / acq_ta_yr__2 if acq_ta_yr__2 > 0

* 3. 杠杆比率 (负债/总资产)
gen acq_leverage_ly = (acq_ta_last_avail_yr - acq_eq_last_avail_yr) / acq_ta_last_avail_yr if acq_ta_last_avail_yr > 0
gen acq_leverage_y1 = (acq_ta_yr__1 - acq_eq_yr__1) / acq_ta_yr__1 if acq_ta_yr__1 > 0
gen acq_leverage_y2 = (acq_ta_yr__2 - acq_eq_yr__2) / acq_ta_yr__2 if acq_ta_yr__2 > 0

* 4. EBITDA利润率
gen acq_ebitda_margin_ly = acq_ebitda_last_avail_yr / acq_rev_rev_last_avail_yr if acq_rev_rev_last_avail_yr > 0
gen acq_ebitda_margin_y1 = acq_ebitda_yr__1 / acq_rev_rev_yr__1 if acq_rev_rev_yr__1 > 0
gen acq_ebitda_margin_y2 = acq_ebitda_yr__2 / acq_rev_rev_yr__2 if acq_rev_rev_yr__2 > 0

* 5. 资产周转率
gen acq_asset_turnover_ly = acq_rev_rev_last_avail_yr / acq_ta_last_avail_yr if acq_ta_last_avail_yr > 0
gen acq_asset_turnover_y1 = acq_rev_rev_yr__1 / acq_ta_yr__1 if acq_ta_yr__1 > 0
gen acq_asset_turnover_y2 = acq_rev_rev_yr__2 / acq_ta_yr__2 if acq_ta_yr__2 > 0

* 6. 流动比率 (如果有流动资产数据)
*gen acq_current_ratio_ly = acq_current_assets_ly / acq_current_liabilities_ly

* 7. 人均指标
*gen acq_rev_per_emp_ly = acq_rev_rev_last_avail_yr / acq_emp_last_avail_yr if acq_emp_last_avail_yr > 0
*gen acq_rev_per_emp_y1 = acq_rev_rev_yr__1 / acq_emp_yr__1 if acq_emp_yr__1 > 0
*gen acq_rev_per_emp_y2 = acq_rev_rev_yr__2 / acq_emp_yr__2 if acq_emp_yr__2 > 0

* 7.5 size指标
gen acq_ta = ln(acq_ta_last_avail_yr) if acq_ta_last_avail_yr > 0
gen acq_ta_y1 = ln(acq_ta_yr__1) if acq_ta_yr__1 > 0
gen acq_ta_y2 = ln(acq_ta_yr__2) if acq_ta_yr__2 > 0
gen acq_emp = ln(acq_emp_last_avail_yr) if acq_emp_last_avail_yr > 0
gen acq_emp_y1 = ln(acq_emp_yr__1) if tar_emp_yr__1 > 0
gen acq_emp_y2 = ln(acq_emp_yr__2) if tar_emp_yr__2 > 0

* 8. 估值比率 (如果EV数据可用)
gen acq_cap = ln(acq_cap_last_avail_yr) if acq_cap_last_avail_yr > 0
gen acq_cap_y1 = ln(acq_cap_yr__1) if acq_cap_yr__1 > 0
gen acq_cap_y2 = ln(acq_cap_yr__2) if acq_cap_yr__2 > 0
gen acq_ev = ln(acq_ev_last_avail_yr) if acq_ev_last_avail_yr > 0
gen acq_ev_y1 = ln(acq_ev_yr__1) if acq_ev_yr__1 > 0
gen acq_ev_y2 = ln(acq_ev_yr__2) if acq_ev_yr__2 > 0
*gen acq_ev_to_rev_ly = acq_ev_last_avail_yr / acq_rev_rev_last_avail_yr if acq_rev_rev_last_avail_yr > 0
*gen acq_ev_to_ebitda_ly = acq_ev_last_avail_yr / acq_ebitda_last_avail_yr if acq_ebitda_last_avail_yr > 0

* 9. 检查计算结果的统计特征
*sum acq_profit_margin_ly acq_roa_ly acq_leverage_ly acq_ebitda_margin_ly acq_asset_turnover_ly

* 10. 标签变量
label variable acq_profit_margin_ly "Acquirer Profit Margin (Last Year)"
label variable acq_roa_ly "Acquirer ROA (Last Year)" 
label variable acq_leverage_ly "Acquirer Leverage Ratio (Last Year)"
label variable acq_ebitda_margin_ly "Acquirer EBITDA Margin (Last Year)"
label variable acq_asset_turnover_ly "Acquirer Asset Turnover (Last Year)"
*label variable acq_rev_per_emp_ly "Acquirer per Employee (Last Year)"


save "`output_path'\acq_com_fin.dta", replace
di "所有文件处理完成，最终合并文件已保存为: `output_path'\acq_com_fin.dta"


// 处理1-8号文件
forvalues i = 1/8 {
    erase "`output_path'\acq_com_fin_`i'.dta"
    }


// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\financial\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\financial"

use "`output_path'\acq_com_fin.dta",clear
keep deal_num tar_rev_rev_last_avail_yr tar_rev_rev_yr__1 tar_rev_rev_yr__2 tar_ebitda_last_avail_yr tar_ebitda_yr__1 tar_ebitda_yr__2 tar_ebit_last_avail_yr tar_ebit_yr__1 tar_ebit_yr__2 tar_pbt_last_avail_yr tar_pbt_yr__1 tar_pbt_yr__2 tar_pat_last_avail_yr tar_pat_yr__1 tar_pat_yr__2 tar_np_last_avail_yr tar_np_yr__1 tar_np_yr__2 tar_ta_last_avail_yr tar_ta_yr__1 tar_ta_yr__2 tar_na_last_avail_yr tar_na_yr__1 tar_na_yr__2 tar_eq_last_avail_yr tar_eq_yr__1 tar_eq_yr__2 tar_cap_last_avail_yr tar_cap_yr__1 tar_cap_yr__2 tar_emp_last_avail_yr tar_emp_yr__1 tar_emp_yr__2 tar_ev_last_avail_yr tar_ev_yr__1 tar_ev_yr__2 tar_eps_last_avail_yr tar_eps_yr__1 tar_eps_yr__2 tar_cfps_last_avail_yr tar_cfps_yr__1 tar_cfps_yr__2 tar_dps_last_avail_yr tar_dps_yr__1 tar_dps_yr__2 tar_bvps_last_avail_yr tar_bvps_yr__1 tar_bvps_yr__2 tar_name tar_bvd_id_num tar_orbis_id_num tar_profit_margin_ly tar_profit_margin_y1 tar_profit_margin_y2 tar_roa_ly tar_roa_y1 tar_roa_y2 tar_leverage_ly tar_leverage_y1 tar_leverage_y2 tar_ebitda_margin_ly tar_ebitda_margin_y1 tar_ebitda_margin_y2 tar_asset_turnover_ly tar_asset_turnover_y1 tar_asset_turnover_y2 tar_rev_per_emp_ly tar_rev_per_emp_y1 tar_rev_per_emp_y2 tar_ta tar_ta_y1 tar_ta_y2 tar_emp tar_emp_y1 tar_emp_y2 tar_cap tar_cap_y1 tar_cap_y2 tar_ev tar_ev_y1 tar_ev_y2
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num: keep if _n == 1
save "`output_path'\acq_tar_fin.dta", replace

use "`output_path'\acq_com_fin.dta",clear
keep  deal_num acq_rev_rev_last_avail_yr acq_rev_rev_yr__1 acq_rev_rev_yr__2 acq_ebitda_last_avail_yr acq_ebitda_yr__1 acq_ebitda_yr__2 acq_ebit_last_avail_yr acq_ebit_yr__1 acq_ebit_yr__2 acq_pbt_last_avail_yr acq_pbt_yr__1 acq_pbt_yr__2 acq_pat_last_avail_yr acq_pat_yr__1 acq_pat_yr__2 acq_np_last_avail_yr acq_np_yr__1 acq_np_yr__2 acq_ta_last_avail_yr acq_ta_yr__1 acq_ta_yr__2 acq_na_last_avail_yr acq_na_yr__1 acq_na_yr__2 acq_eq_last_avail_yr acq_eq_yr__1 acq_eq_yr__2 acq_cap_last_avail_yr acq_cap_yr__1 acq_cap_yr__2 acq_emp_last_avail_yr acq_emp_yr__1 acq_emp_yr__2 acq_ev_last_avail_yr acq_ev_yr__1 acq_ev_yr__2 acq_eps_last_avail_yr acq_eps_yr__1 acq_eps_yr__2 acq_cfps_last_avail_yr acq_cfps_yr__1 acq_cfps_yr__2 acq_dps_last_avail_yr acq_dps_yr__1 acq_dps_yr__2 acq_bvps_last_avail_yr acq_bvps_yr__1 acq_bvps_yr__2 acq_name acq_bvd_id_num acq_bvd_id_number__1 acq_orbis_id_num acq_profit_margin_ly acq_profit_margin_y1 acq_profit_margin_y2 acq_roa_ly acq_roa_y1 acq_roa_y2 acq_leverage_ly acq_leverage_y1 acq_leverage_y2 acq_ebitda_margin_ly acq_ebitda_margin_y1 acq_ebitda_margin_y2 acq_asset_turnover_ly acq_asset_turnover_y1 acq_asset_turnover_y2 acq_ta acq_ta_y1 acq_ta_y2 acq_emp acq_emp_y1 acq_emp_y2 acq_cap acq_cap_y1 acq_cap_y2 acq_ev acq_ev_y1 acq_ev_y2
bysort  deal_num acq_name acq_bvd_id_num acq_orbis_id_num: keep if _n == 1
save "`output_path'\acq_acq_fin.dta", replace


// 首先加载您的数据库
use "`output_path'\acq_com_fin.dta", clear

// 定义需要取对数的财务变量列表
local financial_vars ///
    tar_rev_rev_last_avail_yr tar_rev_rev_yr__1 tar_rev_rev_yr__2 ///
    tar_ebitda_last_avail_yr tar_ebitda_yr__1 tar_ebitda_yr__2 ///
    tar_ebit_last_avail_yr tar_ebit_yr__1 tar_ebit_yr__2 ///
    tar_pbt_last_avail_yr tar_pbt_yr__1 tar_pbt_yr__2 ///
    tar_pat_last_avail_yr tar_pat_yr__1 tar_pat_yr__2 ///
    tar_np_last_avail_yr tar_np_yr__1 tar_np_yr__2 ///
    tar_ta_last_avail_yr tar_ta_yr__1 tar_ta_yr__2 ///
    tar_na_last_avail_yr tar_na_yr__1 tar_na_yr__2 ///
    tar_eq_last_avail_yr tar_eq_yr__1 tar_eq_yr__2 ///
    tar_cap_last_avail_yr tar_cap_yr__1 tar_cap_yr__2 ///
    tar_emp_last_avail_yr tar_emp_yr__1 tar_emp_yr__2 ///
    tar_ev_last_avail_yr tar_ev_yr__1 tar_ev_yr__2 ///
    tar_eps_last_avail_yr tar_eps_yr__1 tar_eps_yr__2 ///
    tar_cfps_last_avail_yr tar_cfps_yr__1 tar_cfps_yr__2 ///
    tar_dps_last_avail_yr tar_dps_yr__1 tar_dps_yr__2 ///
    tar_bvps_last_avail_yr tar_bvps_yr__1 tar_bvps_yr__2 ///
    acq_rev_rev_last_avail_yr acq_rev_rev_yr__1 acq_rev_rev_yr__2 ///
    acq_ebitda_last_avail_yr acq_ebitda_yr__1 acq_ebitda_yr__2 ///
    acq_ebit_last_avail_yr acq_ebit_yr__1 acq_ebit_yr__2 ///
    acq_pbt_last_avail_yr acq_pbt_yr__1 acq_pbt_yr__2 ///
    acq_pat_last_avail_yr acq_pat_yr__1 acq_pat_yr__2 ///
    acq_np_last_avail_yr acq_np_yr__1 acq_np_yr__2 ///
    acq_ta_last_avail_yr acq_ta_yr__1 acq_ta_yr__2 ///
    acq_na_last_avail_yr acq_na_yr__1 acq_na_yr__2 ///
    acq_eq_last_avail_yr acq_eq_yr__1 acq_eq_yr__2 ///
    acq_cap_last_avail_yr acq_cap_yr__1 acq_cap_yr__2 ///
    acq_emp_last_avail_yr acq_emp_yr__1 acq_emp_yr__2 ///
    acq_ev_last_avail_yr acq_ev_yr__1 acq_ev_yr__2 ///
    acq_eps_last_avail_yr acq_eps_yr__1 acq_eps_yr__2 ///
    acq_cfps_last_avail_yr acq_cfps_yr__1 acq_cfps_yr__2 ///
    acq_dps_last_avail_yr acq_dps_yr__1 acq_dps_yr__2 ///
    acq_bvps_last_avail_yr acq_bvps_yr__1 acq_bvps_yr__2 ///
    ven_rev_rev_last_avail_yr ven_rev_rev_yr__1 ven_rev_rev_yr__2 ///
    ven_ebitda_last_avail_yr ven_ebitda_yr__1 ven_ebitda_yr__2 ///
    ven_ebit_last_avail_yr ven_ebit_yr__1 ven_ebit_yr__2 ///
    ven_pbt_last_avail_yr ven_pbt_yr__1 ven_pbt_yr__2 ///
    ven_pat_last_avail_yr ven_pat_yr__1 ven_pat_yr__2 ///
    ven_np_last_avail_yr ven_np_yr__1 ven_np_yr__2 ///
    ven_ta_last_avail_yr ven_ta_yr__1 ven_ta_yr__2 ///
    ven_na_last_avail_yr ven_na_yr__1 ven_na_yr__2 ///
    ven_eq_last_avail_yr ven_eq_yr__1 ven_eq_yr__2 ///
    ven_cap_last_avail_yr ven_cap_yr__1 ven_cap_yr__2 ///
    ven_emp_last_avail_yr ven_emp_yr__1 ven_emp_yr__2 ///
    ven_ev_last_avail_yr ven_ev_yr__1 ven_ev_yr__2 ///
    ven_eps_last_avail_yr ven_eps_yr__1 ven_eps_yr__2 ///
    ven_cfps_last_avail_yr ven_cfps_yr__1 ven_cfps_yr__2 ///
    ven_dps_last_avail_yr ven_dps_yr__1 ven_dps_yr__2 ///
    ven_bvps_last_avail_yr ven_bvps_yr__1 ven_bvps_yr__2

// 为所有财务变量计算自然对数
foreach var of local financial_vars {
    capture confirm variable `var'
    if _rc == 0 {
        // 提取实体信息
        local entity = cond(strpos("`var'", "tar_") == 1, "t", ///
                      cond(strpos("`var'", "acq_") == 1, "a", "v"))
        
        // 提取时间信息
        if strpos("`var'", "_last_avail_yr") > 0 local time "0"
        else if strpos("`var'", "_yr__1") > 0 local time "1"
        else if strpos("`var'", "_yr__2") > 0 local time "2"
        else local time "other"
        
        // 确定财务指标
        if strpos("`var'", "_rev_rev_") > 0 local metric "rev"
        else if strpos("`var'", "_ebitda_") > 0 local metric "ebd"
        else if strpos("`var'", "_ebit_") > 0 local metric "ebt"
        else if strpos("`var'", "_pbt_") > 0 local metric "pbt"
        else if strpos("`var'", "_pat_") > 0 local metric "pat"
        else if strpos("`var'", "_np_") > 0 local metric "np"
        else if strpos("`var'", "_ta_") > 0 local metric "ta"
        else if strpos("`var'", "_na_") > 0 local metric "na"
        else if strpos("`var'", "_eq_") > 0 local metric "eq"
        else if strpos("`var'", "_cap_") > 0 local metric "cap"
        else if strpos("`var'", "_emp_") > 0 local metric "emp"
        else if strpos("`var'", "_ev_") > 0 local metric "ev"
        else if strpos("`var'", "_eps_") > 0 local metric "eps"
        else if strpos("`var'", "_cfps_") > 0 local metric "cfps"
        else if strpos("`var'", "_dps_") > 0 local metric "dps"
        else if strpos("`var'", "_bvps_") > 0 local metric "bvps"
        else local metric "other"
        
        // 创建新变量名
        local newname "ln_`entity'_`metric'_`time'"
        
        // 检查是否已存在，如果存在则添加数字后缀
        capture confirm variable `newname'
        local j = 1
        while _rc == 0 {
            local tempname "`newname'_`j'"
            capture confirm variable `tempname'
            if _rc != 0 {
                local newname "`tempname'"
            }
            local j = `j' + 1
        }
        
        // 生成对数变量（只对正值取对数）
        gen `newname' = ln(`var') if `var' > 0 & `var' != .
        replace `newname' = . if `var' <= 0 | `var' == .
        
        label variable `newname' "ln(`var')"
        di "Created `newname' from `var'"
    }
    else {
        di "Variable `var' not found"
    }
}

// 显示所有新创建的对数变量
*describe ln_*

// 保存处理后的数据
save "`output_path'\acq_com_fin_with_ln.dta", replace

// 显示处理结果摘要
di "数据处理完成！"
di "原始变量数量: " _N
di "新创建的对数变量:"
ds ln_*
local ln_vars = r(varlist)
di "对数变量数量: " `: word count `ln_vars''

