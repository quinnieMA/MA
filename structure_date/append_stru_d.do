// Define the base path to OneDrive
global ONEDRIVE_PATH "D:/OneDrive"  // Change this to match your OneDrive path


// 定义处理单个文件的程序
capture program drop process_file
program define process_file
    args input_file output_file
    
    // 导入CSV文件
    import delimited "`input_file'", bindquote(strict) clear
    
    // +++ 新增部分：确保关键变量为字符串格式 +++
    local str_vars ïunnamed_0 deal_num
    
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
	    local vars_to_process  deal_type deal_struct deal_fin deal_pay_method deal_pay_method_val_usd deal_status rumour_d announced_d expected_comp_d assumed_comp_d completed_d postponed_d withdrawn_d last_deal_status_d last_deal_val_up_d last_deal_status_up_d last_pct_stake_up_d last_acq_tar_ven_up_d last_advisor_up_d last_comment_up_d last_up rumour_d_yr announced_d_yr expected_comp_d_yr assumed_comp_d_yr completed_d_yr postponed_d_yr withdrawn_d_yr last_deal_status_d_yr last_deal_val_up_d_yr last_deal_status_up_d_yr last_pct_stake_up_d_yr last_acq_tar_ven_up_d_yr last_advisor_up_d_yr last_comment_up_d_yr last_up_yr

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
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date"

// 处理1-8号文件
forvalues i = 1/2 {
    local input_file "`input_path'\acquisition_structure_date_`i'_date_cleaned.csv"
    local output_file "`output_path'\acq_stru_d_`i'.dta"
    
    di "正在处理文件 `i'/2: `input_file'"
    process_file "`input_file'" "`output_file'"
}

// 合并所有文件
clear
forvalues i = 1/2 {
    local file "`output_path'\acq_stru_d_`i'.dta"
    append using "`file'"
    di "已追加文件: `file'"
}

    // +++ 新增部分结束 +++
    gen index=_n
	sort index
    // 定义需要处理的新变量列表
    local vars_to_process ïunnamed_0 deal_num 
    // 第1步：执行前向填充（用前一个非缺失值填充当前缺失值）
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
	
	
drop rumour_d-last_up
destring deal_pay_method_val_usd, replace
gen cash=1 if deal_pay_method=="Cash"
replace cash=0 if cash==.
gen stock=1 if deal_pay_method=="Shares"
replace  stock=0 if stock==.
* 为cash变量添加标签
label variable cash "Payment method is Cash"
* 为stock变量添加标签  
label variable stock "Payment method is Stock"

save "`output_path'\temp.dta", replace


use "`output_path'\temp.dta", clear
keep  ïunnamed_0 deal_num deal_struct deal_pay_method deal_pay_method_val_usd
drop if deal_struct==""
bysort deal_num deal_struct deal_pay_method deal_pay_method_val_usd: keep if _n == 1
save "`output_path'\acq_stru.dta", replace

use "`output_path'\temp.dta", clear
keep ïunnamed_0 deal_num deal_fin
drop if deal_fin==""
bysort deal_num deal_fin: keep if _n==1
save "`output_path'\acq_deal_fin.dta", replace

// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date"

use "`output_path'\temp.dta", clear
drop if deal_pay_method==""
keep  ïunnamed_0 deal_num deal_struct deal_pay_method cash stock
bysort deal_num: egen mix_pay=count( deal_pay_method)
bysort deal_num: egen stock_alone=max(stock) if mix_pay==1
bysort deal_num: egen cash_alone=max(cash) if mix_pay==1

replace stock_alone=0 if stock_alone==.
replace cash_alone =0 if cash_alone ==.

bysort deal_num   deal_pay_method : keep if _n==1
save "`output_path'\acq_pay_method_val.dta", replace

drop deal_struct 
bysort deal_num : keep if _n==1
save "`output_path'\acq_pay_method_to_merge.dta", replace


use "`output_path'\temp.dta", clear
drop if deal_status==""
keep  ïunnamed_0 deal_num deal_status
bysort deal_num deal_status: keep if _n==1
save "`output_path'\acq_status.dta", replace


// 定义输入输出路径
local input_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date\cleaned_output"
local output_path "${ONEDRIVE_PATH}\MA1\01-deals\structure_date"


use "`output_path'\temp.dta", clear

keep ïunnamed_0 deal_num announced_d_yr completed_d_yr
drop if announced_d_yr==.

// 检查重复观测
duplicates tag deal_num, gen(dup)
// 查看重复情况
tab dup
list deal_num if dup > 0, abbreviate(5)
// 处理重复项方案1：保留第一条记录
bysort deal_num: keep if _n == 1
drop dup
// 保存最终合并文件
gen length= completed_d_yr - announced_d_yr


save "`output_path'\acq_d.dta", replace
di "所有文件处理完成，最终合并文件已保存为: `output_path'\acq_d.dta"

