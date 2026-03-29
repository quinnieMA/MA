// Define the base path to OneDrive
global ONEDRIVE_PATH "D:/OneDrive"  // Change this to match your OneDrive path

// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars  ïunnamed__0 deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num
    
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
    // +++ 新增部分结束 +++

    // 定义需要处理的新变量列表
    local vars_to_process ïunnamed__0 deal_num pre_deal_tar_rev_rev_last_avail_ pre_deal_tar_ebitda_last_avail_y pre_deal_tar_ebit_last_avail_yr pre_deal_tar_pbt_last_avail_yr pre_deal_tar_pat_last_avail_yr pre_deal_tar_np_last_avail_yr pre_deal_tar_ta_last_avail_yr pre_deal_tar_na_last_avail_yr pre_deal_tar_current_liabilities pre_deal_tar_eq_last_avail_yr pre_deal_tar_cap pre_deal_acq_rev_rev_last_avail_ pre_deal_acq_ebitda_last_avail_y pre_deal_acq_ebit_last_avail_yr pre_deal_acq_pbt_last_avail_yr pre_deal_acq_pat_last_avail_yr pre_deal_acq_np_last_avail_yr pre_deal_acq_ta_last_avail_yr pre_deal_acq_na_last_avail_yr pre_deal_acq_current_liabilities pre_deal_acq_eq_last_avail_yr pre_deal_acq_cap pre_deal_ven_rev_rev_last_avail_ pre_deal_ven_ebitda_last_avail_y pre_deal_ven_ebit_last_avail_yr pre_deal_ven_pbt_last_avail_yr pre_deal_ven_pat_last_avail_yr pre_deal_ven_np_last_avail_yr pre_deal_ven_ta_last_avail_yr pre_deal_ven_na_last_avail_yr pre_deal_ven_current_liabilities pre_deal_ven_eq_last_avail_yr pre_deal_ven_cap post_deal_tar_rev_rev_1st_avail_ post_deal_tar_ebitda_1st_avail_y post_deal_tar_ebit_1st_avail_yr post_deal_tar_pbt_1st_avail_yr post_deal_tar_pat_1st_avail_yr post_deal_tar_np_1st_avail_yr post_deal_tar_ta_1st_avail_yr post_deal_tar_na_1st_avail_yr post_deal_tar_current_liabilitie post_deal_tar_shareholder_funds_ post_deal_tar_cap post_deal_acq_rev_rev_1st_avail_ post_deal_acq_ebitda_1st_avail_y post_deal_acq_ebit_1st_avail_yr post_deal_acq_pbt_1st_avail_yr post_deal_acq_pat_1st_avail_yr post_deal_acq_np_1st_avail_yr post_deal_acq_ta_1st_avail_yr post_deal_acq_na_1st_avail_yr post_deal_acq_shareholder_funds_ post_deal_acq_cap post_deal_ven_rev_rev_1st_avail_ post_deal_ven_ebitda_1st_avail_y post_deal_ven_ebit_1st_avail_yr post_deal_ven_pbt_1st_avail_yr post_deal_ven_pat_1st_avail_yr post_deal_ven_np_1st_avail_yr post_deal_ven_ta_1st_avail_yr post_deal_ven_na_1st_avail_yr post_deal_ven_shareholder_funds_ post_deal_ven_cap tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num

    // 第1步：识别变量类型并只对字符型变量替换"n.a."
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
forvalues i = 1/4 {
    local input_file "`input_path'\acquisition_financial_`i'_cleaned.csv"
    local output_file "`output_path'\acq_fin_`i'.dta"
    
    di "正在处理文件 `i'/4: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/4 {
    local file "`output_path'\acq_fin_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}


    local vars_to_process deal_num 
    // 第2步：执行前向填充（用前一个非缺失值填充当前缺失值）
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
	
// 处理重复项方案1：保留第一条记录
bysort  deal_num tar_name tar_bvd_id_num tar_orbis_id_num acq_name acq_bvd_id_num acq_orbis_id_num ven_name ven_bvd_id_num ven_orbis_id_num: keep if _n == 1

rename ïunnamed__0 ïunnamed_0

destring pre_deal_tar_rev_rev_last_avail_ pre_deal_tar_ebitda_last_avail_y pre_deal_tar_ebit_last_avail_yr pre_deal_tar_pbt_last_avail_yr pre_deal_tar_pat_last_avail_yr pre_deal_tar_np_last_avail_yr pre_deal_tar_ta_last_avail_yr pre_deal_tar_na_last_avail_yr pre_deal_tar_current_liabilities pre_deal_tar_eq_last_avail_yr pre_deal_tar_cap pre_deal_acq_rev_rev_last_avail_ pre_deal_acq_ebitda_last_avail_y pre_deal_acq_ebit_last_avail_yr pre_deal_acq_pbt_last_avail_yr pre_deal_acq_pat_last_avail_yr pre_deal_acq_np_last_avail_yr pre_deal_acq_ta_last_avail_yr pre_deal_acq_na_last_avail_yr pre_deal_acq_current_liabilities pre_deal_acq_eq_last_avail_yr pre_deal_acq_cap pre_deal_ven_rev_rev_last_avail_ pre_deal_ven_ebitda_last_avail_y pre_deal_ven_ebit_last_avail_yr pre_deal_ven_pbt_last_avail_yr pre_deal_ven_pat_last_avail_yr pre_deal_ven_np_last_avail_yr pre_deal_ven_ta_last_avail_yr pre_deal_ven_na_last_avail_yr pre_deal_ven_current_liabilities pre_deal_ven_eq_last_avail_yr pre_deal_ven_cap post_deal_tar_rev_rev_1st_avail_ post_deal_tar_ebitda_1st_avail_y post_deal_tar_ebit_1st_avail_yr post_deal_tar_pbt_1st_avail_yr post_deal_tar_pat_1st_avail_yr post_deal_tar_np_1st_avail_yr post_deal_tar_ta_1st_avail_yr post_deal_tar_na_1st_avail_yr post_deal_tar_current_liabilitie post_deal_tar_shareholder_funds_ post_deal_tar_cap post_deal_acq_rev_rev_1st_avail_ post_deal_acq_ebitda_1st_avail_y post_deal_acq_ebit_1st_avail_yr post_deal_acq_pbt_1st_avail_yr post_deal_acq_pat_1st_avail_yr post_deal_acq_np_1st_avail_yr post_deal_acq_ta_1st_avail_yr post_deal_acq_na_1st_avail_yr post_deal_acq_shareholder_funds_ post_deal_acq_cap post_deal_ven_rev_rev_1st_avail_ post_deal_ven_ebitda_1st_avail_y post_deal_ven_ebit_1st_avail_yr post_deal_ven_pbt_1st_avail_yr post_deal_ven_pat_1st_avail_yr post_deal_ven_np_1st_avail_yr post_deal_ven_ta_1st_avail_yr post_deal_ven_na_1st_avail_yr post_deal_ven_shareholder_funds_ post_deal_ven_cap,replace

* 目标公司(Target)财务比率 - 交易前
* 盈利能力比率
gen tar_pre_profit_margin = pre_deal_tar_pat_last_avail_yr / pre_deal_tar_rev_rev_last_avail_ if pre_deal_tar_rev_rev_last_avail_ > 0 & !missing(pre_deal_tar_rev_rev_last_avail_)
gen tar_pre_roa = pre_deal_tar_ebitda_last_avail_y / pre_deal_tar_ta_last_avail_yr if pre_deal_tar_ta_last_avail_yr > 0 & !missing(pre_deal_tar_ta_last_avail_yr)
gen tar_pre_ebitda_margin = pre_deal_tar_ebitda_last_avail_y / pre_deal_tar_rev_rev_last_avail_ if pre_deal_tar_rev_rev_last_avail_ > 0 & !missing(pre_deal_tar_rev_rev_last_avail_)

* 杠杆与偿债能力比率
gen tar_pre_leverage_ratio = (pre_deal_tar_ta_last_avail_yr - pre_deal_tar_na_last_avail_yr) / pre_deal_tar_ta_last_avail_yr if pre_deal_tar_ta_last_avail_yr > 0 & !missing(pre_deal_tar_ta_last_avail_yr)
gen tar_pre_debt_to_equity = (pre_deal_tar_ta_last_avail_yr - pre_deal_tar_na_last_avail_yr) / pre_deal_tar_na_last_avail_yr if pre_deal_tar_na_last_avail_yr > 0 & !missing(pre_deal_tar_na_last_avail_yr)

* 运营效率比率
gen tar_pre_asset_turnover = pre_deal_tar_rev_rev_last_avail_ / pre_deal_tar_ta_last_avail_yr if pre_deal_tar_ta_last_avail_yr > 0 & !missing(pre_deal_tar_ta_last_avail_yr)
gen tar_pre_return_on_equity = pre_deal_tar_pat_last_avail_yr / pre_deal_tar_na_last_avail_yr if pre_deal_tar_na_last_avail_yr > 0 & !missing(pre_deal_tar_na_last_avail_yr)

* 规模指标（对数化处理）
gen tar_pre_log_assets = ln(pre_deal_tar_ta_last_avail_yr) if pre_deal_tar_ta_last_avail_yr > 0 & !missing(pre_deal_tar_ta_last_avail_yr)
gen tar_pre_log_market_cap = ln(pre_deal_tar_cap) if pre_deal_tar_cap > 0 & !missing(pre_deal_tar_cap)

* 估值比率
gen tar_pre_ev_to_ebitda = pre_deal_tar_cap / pre_deal_tar_ebitda_last_avail_y if pre_deal_tar_ebitda_last_avail_y > 0 & !missing(pre_deal_tar_ebitda_last_avail_y)
gen tar_pre_pe_ratio = pre_deal_tar_cap / pre_deal_tar_pat_last_avail_yr if pre_deal_tar_pat_last_avail_yr > 0 & !missing(pre_deal_tar_pat_last_avail_yr)


* 收购方(Acquirer)财务比率 - 交易前
* 盈利能力比率
gen acq_pre_profit_margin = pre_deal_acq_pat_last_avail_yr / pre_deal_acq_rev_rev_last_avail_ if pre_deal_acq_rev_rev_last_avail_ > 0 & !missing(pre_deal_acq_rev_rev_last_avail_)
gen acq_pre_roa = pre_deal_acq_ebitda_last_avail_y / pre_deal_acq_ta_last_avail_yr if pre_deal_acq_ta_last_avail_yr > 0 & !missing(pre_deal_acq_ta_last_avail_yr)
gen acq_pre_ebitda_margin = pre_deal_acq_ebitda_last_avail_y / pre_deal_acq_rev_rev_last_avail_ if pre_deal_acq_rev_rev_last_avail_ > 0 & !missing(pre_deal_acq_rev_rev_last_avail_)

* 杠杆与偿债能力比率
gen acq_pre_leverage_ratio = (pre_deal_acq_ta_last_avail_yr - pre_deal_acq_na_last_avail_yr) / pre_deal_acq_ta_last_avail_yr if pre_deal_acq_ta_last_avail_yr > 0 & !missing(pre_deal_acq_ta_last_avail_yr)
gen acq_pre_debt_to_equity = (pre_deal_acq_ta_last_avail_yr - pre_deal_acq_na_last_avail_yr) / pre_deal_acq_na_last_avail_yr if pre_deal_acq_na_last_avail_yr > 0 & !missing(pre_deal_acq_na_last_avail_yr)

* 运营效率比率
gen acq_pre_asset_turnover = pre_deal_acq_rev_rev_last_avail_ / pre_deal_acq_ta_last_avail_yr if pre_deal_acq_ta_last_avail_yr > 0 & !missing(pre_deal_acq_ta_last_avail_yr)
gen acq_pre_return_on_equity = pre_deal_acq_pat_last_avail_yr / pre_deal_acq_na_last_avail_yr if pre_deal_acq_na_last_avail_yr > 0 & !missing(pre_deal_acq_na_last_avail_yr)

* 规模指标
gen acq_pre_log_assets = ln(pre_deal_acq_ta_last_avail_yr) if pre_deal_acq_ta_last_avail_yr > 0 & !missing(pre_deal_acq_ta_last_avail_yr)
gen acq_pre_log_market_cap = ln(pre_deal_acq_cap) if pre_deal_acq_cap > 0 & !missing(pre_deal_acq_cap)


* 交易后财务比率 - 目标公司
gen tar_post_profit_margin = post_deal_tar_pat_1st_avail_yr / post_deal_tar_rev_rev_1st_avail_ if post_deal_tar_rev_rev_1st_avail_ > 0 & !missing(post_deal_tar_rev_rev_1st_avail_)
gen tar_post_roa = post_deal_tar_ebitda_1st_avail_y / post_deal_tar_ta_1st_avail_yr if post_deal_tar_ta_1st_avail_yr > 0 & !missing(post_deal_tar_ta_1st_avail_yr)
gen tar_post_asset_turnover = post_deal_tar_rev_rev_1st_avail_ / post_deal_tar_ta_1st_avail_yr if post_deal_tar_ta_1st_avail_yr > 0 & !missing(post_deal_tar_ta_1st_avail_yr)


* 交易后财务比率 - 收购方
gen acq_post_profit_margin = post_deal_acq_pat_1st_avail_yr / post_deal_acq_rev_rev_1st_avail_ if post_deal_acq_rev_rev_1st_avail_ > 0 & !missing(post_deal_acq_rev_rev_1st_avail_)
gen acq_post_roa = post_deal_acq_ebitda_1st_avail_y / post_deal_acq_ta_1st_avail_yr if post_deal_acq_ta_1st_avail_yr > 0 & !missing(post_deal_acq_ta_1st_avail_yr)
gen acq_post_asset_turnover = post_deal_acq_rev_rev_1st_avail_ / post_deal_acq_ta_1st_avail_yr if post_deal_acq_ta_1st_avail_yr > 0 & !missing(post_deal_acq_ta_1st_avail_yr)


* 相对绩效指标（收购方vs目标方）
gen relative_profit_margin_pre = acq_pre_profit_margin - tar_pre_profit_margin
gen relative_roa_pre = acq_pre_roa - tar_pre_roa
gen relative_size_pre = acq_pre_log_assets - tar_pre_log_assets
gen relative_leverage_pre = acq_pre_leverage_ratio - tar_pre_leverage_ratio


* 绩效变化指标（交易后-交易前）
gen tar_roa_change = tar_post_roa - tar_pre_roa
gen acq_roa_change = acq_post_roa - acq_pre_roa
gen tar_profit_margin_change = tar_post_profit_margin - tar_pre_profit_margin
gen acq_profit_margin_change = acq_post_profit_margin - acq_pre_profit_margin


* 添加变量标签
label variable tar_pre_profit_margin "Target Pre-deal Profit Margin (PAT/Revenue)"
label variable tar_pre_roa "Target Pre-deal Return on Assets (EBITDA/Total Assets)"
label variable tar_pre_ebitda_margin "Target Pre-deal EBITDA Margin"
label variable tar_pre_leverage_ratio "Target Pre-deal Leverage Ratio (Debt/Total Assets)"
label variable tar_pre_debt_to_equity "Target Pre-deal Debt-to-Equity Ratio"
label variable tar_pre_asset_turnover "Target Pre-deal Asset Turnover"
label variable tar_pre_return_on_equity "Target Pre-deal Return on Equity"
label variable tar_pre_log_assets "Target Pre-deal Log(Total Assets)"
label variable tar_pre_log_market_cap "Target Pre-deal Log(Market Capitalization)"
label variable tar_pre_ev_to_ebitda "Target Pre-deal EV/EBITDA Ratio"
label variable tar_pre_pe_ratio "Target Pre-deal P/E Ratio"

label variable acq_pre_profit_margin "Acquirer Pre-deal Profit Margin (PAT/Revenue)"
label variable acq_pre_roa "Acquirer Pre-deal Return on Assets (EBITDA/Total Assets)"
label variable acq_pre_ebitda_margin "Acquirer Pre-deal EBITDA Margin"
label variable acq_pre_leverage_ratio "Acquirer Pre-deal Leverage Ratio"
label variable acq_pre_debt_to_equity "Acquirer Pre-deal Debt-to-Equity Ratio"
label variable acq_pre_asset_turnover "Acquirer Pre-deal Asset Turnover"
label variable acq_pre_return_on_equity "Acquirer Pre-deal Return on Equity"
label variable acq_pre_log_assets "Acquirer Pre-deal Log(Total Assets)"
label variable acq_pre_log_market_cap "Acquirer Pre-deal Log(Market Capitalization)"

label variable relative_profit_margin_pre "Relative Profit Margin (Acquirer-Target) Pre-deal"
label variable relative_roa_pre "Relative ROA (Acquirer-Target) Pre-deal"
label variable relative_size_pre "Relative Size (Acquirer-Target) Pre-deal"
label variable relative_leverage_pre "Relative Leverage (Acquirer-Target) Pre-deal"

label variable tar_roa_change "Target ROA Change (Post-Pre)"
label variable acq_roa_change "Acquirer ROA Change (Post-Pre)"
label variable tar_profit_margin_change "Target Profit Margin Change (Post-Pre)"
label variable acq_profit_margin_change "Acquirer Profit Margin Change (Post-Pre)"


* 检查生成变量的统计特征
sum tar_pre_profit_margin tar_pre_roa tar_pre_leverage_ratio tar_pre_ebitda_margin tar_pre_asset_turnover
sum acq_pre_profit_margin acq_pre_roa acq_pre_leverage_ratio acq_pre_ebitda_margin acq_pre_asset_turnover
sum relative_profit_margin_pre relative_roa_pre relative_size_pre relative_leverage_pre
sum tar_roa_change acq_roa_change tar_profit_margin_change acq_profit_margin_change

// 保存最终合并文件
save "`output_path'\acq_fin_all.dta", replace
di "所有文件处理完成，最终合并文件已保存为: `output_path'\acq_fin.dta"

// 处理1-4号文件
forvalues i = 1/4 {
    erase "`output_path'\acq_fin_`i'.dta"
    }


local input_path "${ONEDRIVE_PATH}\MA1\01-deals\financial\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\financial"

use "`output_path'\acq_fin_all.dta",clear
keep deal_num tar_name tar_bvd_id_num tar_orbis_id_num tar_pre_profit_margin tar_pre_roa tar_pre_ebitda_margin tar_pre_leverage_ratio tar_pre_debt_to_equity tar_pre_asset_turnover tar_pre_return_on_equity tar_pre_log_assets tar_pre_log_market_cap tar_pre_ev_to_ebitda tar_pre_pe_ratio tar_post_profit_margin tar_post_roa tar_post_asset_turnover relative_profit_margin_pre relative_roa_pre relative_size_pre relative_leverage_pre tar_roa_change tar_profit_margin_change
bysort deal_num tar_name tar_bvd_id_num tar_orbis_id_num: keep if _n == 1
save "`output_path'\tar_fin.dta", replace

use "`output_path'\acq_fin_all.dta",clear
keep deal_num acq_name acq_bvd_id_num acq_orbis_id_num acq_pre_profit_margin acq_pre_roa acq_pre_ebitda_margin acq_pre_leverage_ratio acq_pre_debt_to_equity acq_pre_asset_turnover acq_pre_return_on_equity acq_pre_log_assets acq_pre_log_market_cap acq_post_profit_margin acq_post_roa acq_post_asset_turnover relative_profit_margin_pre relative_roa_pre relative_size_pre relative_leverage_pre acq_roa_change acq_profit_margin_change
bysort  deal_num acq_name acq_bvd_id_num acq_orbis_id_num: keep if _n == 1
save "`output_path'\acq_fin.dta", replace

	
use "`output_path'\acq_fin_all.dta", clear
// 为所有财务变量计算自然对数并创建简洁的新变量名
local financial_vars ///
    pre_deal_tar_rev_rev_last_avail_ ///
    pre_deal_tar_ebitda_last_avail_y ///
    pre_deal_tar_ebit_last_avail_yr ///
    pre_deal_tar_pbt_last_avail_yr ///
    pre_deal_tar_pat_last_avail_yr ///
    pre_deal_tar_np_last_avail_yr ///
    pre_deal_tar_ta_last_avail_yr ///
    pre_deal_tar_na_last_avail_yr ///
    pre_deal_tar_current_liabilities ///
    pre_deal_tar_eq_last_avail_yr ///
    pre_deal_tar_cap ///
    pre_deal_acq_rev_rev_last_avail_ ///
    pre_deal_acq_ebitda_last_avail_y ///
    pre_deal_acq_ebit_last_avail_yr ///
    pre_deal_acq_pbt_last_avail_yr ///
    pre_deal_acq_pat_last_avail_yr ///
    pre_deal_acq_np_last_avail_yr ///
    pre_deal_acq_ta_last_avail_yr ///
    pre_deal_acq_na_last_avail_yr ///
    pre_deal_acq_current_liabilities ///
    pre_deal_acq_eq_last_avail_yr ///
    pre_deal_acq_cap ///
    pre_deal_ven_rev_rev_last_avail_ ///
    pre_deal_ven_ebitda_last_avail_y ///
    pre_deal_ven_ebit_last_avail_yr ///
    pre_deal_ven_pbt_last_avail_yr ///
    pre_deal_ven_pat_last_avail_yr ///
    pre_deal_ven_np_last_avail_yr ///
    pre_deal_ven_ta_last_avail_yr ///
    pre_deal_ven_na_last_avail_yr ///
    pre_deal_ven_current_liabilities ///
    pre_deal_ven_eq_last_avail_yr ///
    pre_deal_ven_cap ///
    post_deal_tar_rev_rev_1st_avail_ ///
    post_deal_tar_ebitda_1st_avail_y ///
    post_deal_tar_ebit_1st_avail_yr ///
    post_deal_tar_pbt_1st_avail_yr ///
    post_deal_tar_pat_1st_avail_yr ///
    post_deal_tar_np_1st_avail_yr ///
    post_deal_tar_ta_1st_avail_yr ///
    post_deal_tar_na_1st_avail_yr ///
    post_deal_tar_current_liabilitie ///
    post_deal_tar_shareholder_funds_ ///
    post_deal_tar_cap ///
    post_deal_acq_rev_rev_1st_avail_ ///
    post_deal_acq_ebitda_1st_avail_y ///
    post_deal_acq_ebit_1st_avail_yr ///
    post_deal_acq_pbt_1st_avail_yr ///
    post_deal_acq_pat_1st_avail_yr ///
    post_deal_acq_np_1st_avail_yr ///
    post_deal_acq_ta_1st_avail_yr ///
    post_deal_acq_na_1st_avail_yr ///
    post_deal_acq_shareholder_funds_ ///
    post_deal_acq_cap ///
    post_deal_ven_rev_rev_1st_avail_ ///
    post_deal_ven_ebitda_1st_avail_y ///
    post_deal_ven_ebit_1st_avail_yr ///
    post_deal_ven_pbt_1st_avail_yr ///
    post_deal_ven_pat_1st_avail_yr ///
    post_deal_ven_np_1st_avail_yr ///
    post_deal_ven_ta_1st_avail_yr ///
    post_deal_ven_na_1st_avail_yr ///
    post_deal_ven_shareholder_funds_ ///
    post_deal_ven_cap


// 或者使用更直接的命名规则
foreach var of local financial_vars {
    capture confirm variable `var'
    if _rc == 0 {
        // 提取基本信息
        local time = cond(strpos("`var'", "pre_deal") > 0, "pre", "post")
        local entity = cond(strpos("`var'", "_tar_") > 0, "t", cond(strpos("`var'", "_acq_") > 0, "a", "v"))
        
        // 确定财务指标
        if strpos("`var'", "rev") > 0 local metric "rev"
        else if strpos("`var'", "ebitda") > 0 local metric "ebd"
        else if strpos("`var'", "ebit") > 0 local metric "ebt"
        else if strpos("`var'", "pbt") > 0 local metric "pbt"
        else if strpos("`var'", "pat") > 0 local metric "pat"
        else if strpos("`var'", "np") > 0 local metric "np"
        else if strpos("`var'", "ta") > 0 local metric "ta"
        else if strpos("`var'", "na") > 0 local metric "na"
        else if strpos("`var'", "current_liabilities") > 0 local metric "cl"
        else if strpos("`var'", "eq") > 0 local metric "eq"
        else if strpos("`var'", "cap") > 0 local metric "cap"
        else if strpos("`var'", "shareholder_funds") > 0 local metric "sh"
        else local metric "other"
        
        // 创建变量名
        local newname "ln_`time'_`entity'_`metric'"
        
        // 检查是否已存在，如果存在则添加数字后缀
        capture confirm variable `newname'
        local j = 1
        while _rc == 0 {
            local tempname "`newname'`j'"
            capture confirm variable `tempname'
            if _rc != 0 {
                local newname "`tempname'"
            }
            local j = `j' + 1
        }
        
        // 生成对数变量
        gen `newname' = ln(`var') if `var' > 0
        replace `newname' = . if `var' <= 0
        
        label variable `newname' "ln(`var')"
        di "Created `newname' from `var'"
    }
}

// 显示所有新创建的对数变量
describe ln_*
save "`output_path'\acq_fin_with_ln.dta", replace

// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\financial\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\financial"
